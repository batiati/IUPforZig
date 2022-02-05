/// Cells
/// Challenges: change propagation, widget customization, implementing a more authentic/involved GUI application.
/// https://eugenkiss.github.io/7guis/tasks
const std = @import("std");
const iup = @import("iup");
const Allocator = std.mem.Allocator;
const GeneralPurposeAllocator = std.heap.GeneralPurposeAllocator(.{});

pub fn main() anyerror!void {
    var gpa = GeneralPurposeAllocator{};
    defer _ = gpa.deinit();

    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var cells = try Cells.init(gpa.allocator());
    defer cells.deinit();

    try cells.show();
    try iup.MainLoop.beginLoop();
}

const Cells = struct {
    const Self = @This();

    allocator: Allocator,
    fixed_buffer: []u8,
    spreadsheet: Spreadsheet,
    dialog: *iup.Dialog = undefined,

    pub fn init(allocator: Allocator) !*Self {
        var self = try allocator.create(Self);

        self.* = .{
            .allocator = allocator,
            .fixed_buffer = try allocator.alloc(u8, 256),
            .spreadsheet = try Spreadsheet.init(allocator),
        };

        try self.createDialog();
        return self;
    }

    pub fn deinit(self: *Self) void {
        self.dialog.deinit();
        self.allocator.free(self.fixed_buffer);
        self.spreadsheet.deinit();
        self.allocator.destroy(self);
    }

    pub fn show(self: *Self) !void {
        try self.dialog.showXY(.Center, .Center);
    }

    fn createDialog(self: *Self) !void {
        self.dialog = try iup.Dialog.init()
            .setPtrAttribute(Self, "parent", self)
            .setTitle("Cells")
            .setSize(.Half, .Half)
            .setChildren(
            .{
                iup.VBox.init()
                    .setChildren(
                    .{
                        iup.Matrix.init().setExpand(.Yes)
                            .setValueCallback(onValue)
                            .setValueEditCallback(onValueEdit)
                            .setNumCol(26)
                            .setNumLin(100)
                            .setWidth(0, 15)
                            .setHeight(0, 8)
                            .setWidthDef(40)
                            .setResizeMatrix(true)
                            .setMarkMultiple(true)
                            .setMarkMode(.Cell),
                        iup.HBox.init()
                            .setMargin(10, 10)
                            .setChildren(
                            .{
                                iup.Label.init()
                                    .setExpand(.Horizontal)
                                    .setTitle(
                                    \\Tip: use formulas to calculate some fun stuff!
                                    \\Example =SUM(A1:A10)
                                    \\Supported functions are SUM, MIN, MAX, AVG and COUNT
                                    \\Expressions like +, -, /, * are not supported yet
                                ),
                            },
                        ),
                    },
                ),
            },
        ).unwrap();
    }

    fn onValue(matrix: *iup.Matrix, row: i32, col: i32) [:0]const u8 {
        const dialog = matrix.getDialog() orelse unreachable;
        const self = dialog.getPtrAttribute(Self, "parent") orelse @panic("Parent struct not set!");

        const EMPTY = "";
        if (row == 0 and col == 0) return EMPTY;

        var fba = std.heap.FixedBufferAllocator.init(self.fixed_buffer);
        var allocator = fba.allocator();

        if (row == 0) return Cell.getColName(allocator, col) catch return Cell.ERR;
        if (col == 0) return Cell.getRowName(allocator, row) catch return Cell.ERR;

        if (self.spreadsheet.getCell(row, col)) |cell| {
            if (matrix.getEditCell()) |edit_pos| {
                if (edit_pos.lin == row and edit_pos.col == col) {
                    return cell.editText(allocator, &self.spreadsheet) catch return Cell.ERR;
                }
            }

            return cell.displayText(allocator, &self.spreadsheet) catch return Cell.ERR;
        } else {
            return EMPTY;
        }
    }

    fn onValueEdit(matrix: *iup.Matrix, row: i32, col: i32, value: [:0]const u8) !void {
        const dialog = matrix.getDialog() orelse unreachable;
        const self = dialog.getPtrAttribute(Self, "parent") orelse @panic("Parent struct not set!");

        try self.spreadsheet.editCell(row, col, value);
    }
};

const Spreadsheet = struct {
    const Self = @This();

    cells: std.AutoHashMap(Cell.Index, Cell),

    pub fn init(allocator: Allocator) !Self {
        return Self{
            .cells = std.AutoHashMap(Cell.Index, Cell).init(allocator),
        };
    }

    pub fn deinit(self: *Self) void {
        const allocator = self.cells.allocator;
        var iterator = self.cells.valueIterator();
        while (iterator.next()) |cell| {
            cell.free(allocator);
        }

        self.cells.deinit();
    }

    pub fn getCell(self: *const Self, row: i32, col: i32) ?Cell {
        return self.cells.get(.{ .row = row, .col = col });
    }

    pub fn editCell(self: *Self, row: i32, col: i32, value: [:0]const u8) !void {
        const index = Cell.Index{ .row = row, .col = col };

        var entry = try self.cells.getOrPut(index);
        if (!entry.found_existing) {
            entry.value_ptr.* = Cell{ .index = index, .data = .Empty };
        }

        const allocator = self.cells.allocator;

        var cell = entry.value_ptr;
        cell.free(allocator);

        if (value.len == 0) {
            cell.data = .Empty;
        } else if (std.fmt.parseInt(i32, value, 10) catch null) |int| {
            cell.data = .{ .Int = int };
        } else if (std.fmt.parseFloat(f64, value) catch null) |float| {
            cell.data = .{ .Float = float };
        } else if (Formula.validate(allocator, value) catch null) |formula| {
            cell.data = .{ .Formula = formula };
        } else {
            cell.data = .{ .Str = try allocator.dupeZ(u8, value) };
        }
    }

    test "editing" {
        var allocator = std.testing.allocator;
        var self = try Self.init(allocator);
        defer self.deinit();

        try self.editCell(1, 1, "100");
        var a1 = self.getCell(1, 1) orelse {
            try std.testing.expect(false);
            return;
        };

        try std.testing.expect(a1.data == .Int);
        try std.testing.expect(a1.data.Int == 100);

        try self.editCell(2, 1, "99.50");
        var a2 = self.getCell(2, 1) orelse {
            try std.testing.expect(false);
            return;
        };

        try std.testing.expect(a2.data == .Float);
        try std.testing.expect(a2.data.Float == 99.50);

        try self.editCell(3, 3, "Hello");
        var c3 = self.getCell(3, 3) orelse {
            try std.testing.expect(false);
            return;
        };

        try std.testing.expect(c3.data == .Str);
        try std.testing.expectEqualStrings("Hello", c3.data.Str);
    }

    test "formula" {
        var allocator = std.testing.allocator;
        var self = try Self.init(allocator);
        defer self.deinit();

        try self.editCell(1, 1, "100");
        try self.editCell(2, 1, "99.50");

        try self.editCell(3, 1, "=SUM(a1:a2)");

        var a3 = self.getCell(3, 1) orelse {
            try std.testing.expect(false);
            return;
        };

        try std.testing.expect(a3.data == .Formula);
        var eval_a3 = a3.value(&self) orelse {
            try std.testing.expect(false);
            return;
        };

        try std.testing.expect(eval_a3 == 199.50);
    }
};

const Cell = struct {
    const Self = @This();

    pub const ERR = "#ERROR";

    pub const Index = struct {
        row: i32,
        col: i32,
    };

    pub const Data = union(enum) {
        Empty: void,
        Str: [:0]const u8,
        Int: i32,
        Float: f64,
        Formula: Formula,
    };

    index: Index,
    data: Data,

    pub fn getColName(allocator: Allocator, col: i32) ![:0]const u8 {
        var list = std.ArrayList(u8).init(allocator);
        try list.append(@intCast(u8, 'A' + col - 1));
        try list.append(0);

        return std.meta.assumeSentinel(list.toOwnedSlice(), 0);
    }

    pub fn getRowName(allocator: Allocator, row: i32) ![:0]const u8 {
        return try std.fmt.allocPrintZ(allocator, "{}", .{row});
    }

    pub fn parseIndex(index: []const u8) ?Index {
        std.log.debug("parse {s}", .{index});

        if (index.len < 2) return null;
        if (!std.ascii.isAlpha(index[0])) return null;
        if (std.fmt.parseInt(i32, index[1..], 10)) |row| {
            return Index{
                .col = @intCast(i32, std.ascii.toUpper(index[0]) - 'A' + 1),
                .row = row,
            };
        } else |_| {
            return null;
        }
    }

    pub fn displayText(self: *const Self, allocator: Allocator, spreadsheet: *const Spreadsheet) ![:0]const u8 {
        switch (self.data) {
            .Empty => return "",
            .Str => |str| return str,
            .Int => |int| return try std.fmt.allocPrintZ(allocator, "{}", .{int}),
            .Float => |float| return try std.fmt.allocPrintZ(allocator, "{d:.2}", .{float}),
            .Formula => |formula| {
                if (formula.value(spreadsheet)) |eval| {
                    return try std.fmt.allocPrintZ(allocator, "{d:.2}", .{eval});
                } else {
                    return Cell.ERR;
                }
            },
        }
    }

    pub fn editText(self: *const Self, allocator: Allocator, spreadsheet: *const Spreadsheet) ![:0]const u8 {
        switch (self.data) {
            .Formula => |formula| return formula.text,
            else => return self.displayText(allocator, spreadsheet),
        }
    }

    pub fn value(self: *const Self, spreadsheet: *const Spreadsheet) ?f64 {
        switch (self.data) {
            .Empty => return null,
            .Str => return null,
            .Int => |int| return @intToFloat(f64, int),
            .Float => |float| return float,
            .Formula => |formula| return formula.value(spreadsheet),
        }
    }

    pub fn free(self: Self, allocator: Allocator) void {
        switch (self.data) {
            .Str => |str| allocator.free(str),
            .Formula => |formula| formula.free(allocator),
            else => {},
        }
    }

    test "parse index" {
        var a1 = Self.parseIndex("A1");
        try std.testing.expect(a1 != null);
        try std.testing.expectEqual(@as(i32, 1), a1.?.col);
        try std.testing.expectEqual(@as(i32, 1), a1.?.row);

        var b20 = Self.parseIndex("B20");
        try std.testing.expect(b20 != null);
        try std.testing.expectEqual(@as(i32, 2), b20.?.col);
        try std.testing.expectEqual(@as(i32, 20), b20.?.row);

        try std.testing.expect(Self.parseIndex("INCORRECT") == null);
        try std.testing.expect(Self.parseIndex("10A") == null);
        try std.testing.expect(Self.parseIndex("") == null);
        try std.testing.expect(Self.parseIndex("1") == null);
        try std.testing.expect(Self.parseIndex("A") == null);
    }
};

const Formula = struct {
    const Self = @This();

    const FunctionType = enum {
        Identity,
        Sum,
        Avg,
        Min,
        Max,
        Count,
    };

    text: [:0]const u8,
    err: bool = undefined,
    cells: []Cell.Index = undefined,
    function_type: FunctionType = undefined,

    pub fn validate(allocator: Allocator, input_text: [:0]const u8) !?Self {
        if (input_text.len < 2 or !std.ascii.startsWithIgnoreCase(input_text, "=")) return null;

        var self = Self{ .text = try allocator.dupeZ(u8, input_text) };

        try self.parse(allocator);
        return self;
    }

    pub fn free(self: *const Self, allocator: Allocator) void {
        allocator.free(self.text);
        allocator.free(self.cells);
    }

    fn parse(self: *Self, allocator: Allocator) !void {
        var args: []const u8 = undefined;

        // It's just a poor man's parse ...
        // Maybe I reimplement it using https://github.com/Hejsil/mecha 👀

        if (std.ascii.startsWithIgnoreCase(self.text, "=SUM(")) {
            self.function_type = .Sum;
            args = self.text[5..];
        } else if (std.ascii.startsWithIgnoreCase(self.text, "=MIN(")) {
            self.function_type = .Min;
            args = self.text[5..];
        } else if (std.ascii.startsWithIgnoreCase(self.text, "=MAX(")) {
            self.function_type = .Max;
            args = self.text[5..];
        } else if (std.ascii.startsWithIgnoreCase(self.text, "=COUNT(")) {
            self.function_type = .Count;
            args = self.text[7..];
        } else if (std.ascii.startsWithIgnoreCase(self.text, "=AVG(")) {
            self.function_type = .Avg;
            args = self.text[5..];
        } else {
            self.err = true;
            return;
        }

        if (!std.ascii.endsWithIgnoreCase(args, ")")) {
            self.err = true;
            return;
        } else {
            self.cells = getInterval(allocator, args[0 .. args.len - 1]) orelse {
                self.err = true;
                return;
            };
        }

        self.err = false;
    }

    fn getInterval(allocator: Allocator, args: []const u8) ?[]Cell.Index {
        var args_iterator = std.mem.split(u8, args, ":");
        var initial = args_iterator.next() orelse return null;
        var final = args_iterator.next() orelse return null;
        if (args_iterator.next() != null) return null;

        const initial_index = Cell.parseIndex(initial) orelse return null;
        const final_index = Cell.parseIndex(final) orelse return null;

        var list = std.ArrayList(Cell.Index).init(allocator);

        var col: i32 = initial_index.col;
        while (col <= final_index.col) : (col += 1) {
            var row: i32 = initial_index.row;
            while (row <= final_index.row) : (row += 1) {
                list.append(.{ .row = row, .col = col }) catch {
                    list.deinit();
                    return null;
                };
            }
        }

        return list.toOwnedSlice();
    }

    pub fn value(self: *const Self, spreadsheet: *const Spreadsheet) ?f64 {
        if (self.err) return null;

        const allocator = spreadsheet.cells.allocator;
        var cells = std.ArrayList(f64).init(allocator);
        defer cells.deinit();

        for (self.cells) |index| {
            var cell = spreadsheet.getCell(index.row, index.col) orelse continue;
            var cell_value = cell.value(spreadsheet) orelse continue;
            cells.append(cell_value) catch continue;
        }

        switch (self.function_type) {
            .Identity => return if (cells.items.len == 1) cells.items[0] else null,
            .Sum => return sum(cells.items),
            .Avg => return avg(cells.items),
            .Min => return find(cells.items, .Min),
            .Max => return find(cells.items, .Max),
            .Count => return @intToFloat(f64, cells.items.len),
        }
    }

    fn sum(values: []f64) f64 {
        var result: f64 = 0;
        for (values) |item| {
            result += item;
        }

        return result;
    }

    fn avg(values: []f64) f64 {
        return sum(values) / @intToFloat(f64, values.len);
    }

    fn find(values: []f64, op: enum { Min, Max }) f64 {
        if (values.len == 0) return 0;
        if (values.len == 1) return values[0];

        var result = values[0];

        for (values[1..]) |item| {
            if ((op == .Min and item < result) or (op == .Max and item > result)) {
                result = item;
            }
        }

        return result;
    }

    test "parse formula" {
        var arena = std.heap.ArenaAllocator.init(std.testing.allocator);
        defer arena.deinit();

        const allocator = arena.allocator();

        try std.testing.expect((try Formula.validate(allocator, "INCORRECT")) == null);
        try std.testing.expect((try Formula.validate(allocator, "")) == null);
        try std.testing.expect((try Formula.validate(allocator, "A1")) == null);
        try std.testing.expect((try Formula.validate(allocator, "100")) == null);

        try std.testing.expect((try Formula.validate(allocator, "=SUM()")).?.err == true);
        try std.testing.expect((try Formula.validate(allocator, "=SUM(0)")).?.err == true);
        try std.testing.expect((try Formula.validate(allocator, "=SUM(0:0)")).?.err == true);
        try std.testing.expect((try Formula.validate(allocator, "=SUM(A0)")).?.err == true);

        try std.testing.expect((try Formula.validate(allocator, "=SUM(A10:B10)")).?.function_type == .Sum);
        try std.testing.expect((try Formula.validate(allocator, "=Min(A10:B10)")).?.function_type == .Min);
        try std.testing.expect((try Formula.validate(allocator, "=max(A10:B10)")).?.function_type == .Max);
        try std.testing.expect((try Formula.validate(allocator, "=avg(A10:B10)")).?.function_type == .Avg);
        try std.testing.expect((try Formula.validate(allocator, "=COUNT(A10:B10)")).?.function_type == .Count);

        var formula = (try Formula.validate(allocator, "=SUM(A1:A10)")) orelse {
            try std.testing.expect(false);
            return;
        };

        try std.testing.expectEqualStrings("=SUM(A1:A10)", formula.text);
        try std.testing.expect(formula.err == false);
        try std.testing.expect(formula.function_type == .Sum);
        try std.testing.expect(formula.cells.len == 10);
    }
};
