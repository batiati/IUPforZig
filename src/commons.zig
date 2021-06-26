const std = @import("std");
const c = @import("c.zig");

const ascii = std.ascii;
const testing = std.testing;

pub const Error = error{
    ///
    /// Open function must be called before any action
    NotInitialized,

    ///
    /// Only in UNIX can fail to open, because X-Windows may be not initialized.
    OpenFailed,

    ///
    /// Wrong child usage
    InvalidChild,
};

pub const masks = struct {
    pub const float = "[+/-]?(/d+/.?/d*|/./d+)";
    pub const u_float = "(/d+/.?/d*|/./d+)";
    pub const e_float = "[+/-]?(/d+/.?/d*|/./d+)([eE][+/-]?/d+)?";
    pub const ue_float = "(/d+/.?/d*|/./d+)([eE][+/-]?/d+)?";
    pub const float_comma = "[+/-]?(/d+/,?/d*|/,/d+)";
    pub const u_float_comma = "(/d+/,?/d*|/,/d+)";
    pub const int = "[+/-]?/d+";
    pub const u_int = "/d+";
};

pub const ScreenSize = union(enum) {
    Full,
    Half,
    Third,
    Quarter,
    Eighth,
    Size: u32,

    pub fn parse(value: []const u8) ?ScreenSize {
        if (ascii.eqlIgnoreCase(value, @tagName(.Full))) return .Full;
        if (ascii.eqlIgnoreCase(value, @tagName(.Half))) return .Half;
        if (ascii.eqlIgnoreCase(value, @tagName(.Third))) return .Third;
        if (ascii.eqlIgnoreCase(value, @tagName(.Quarter))) return .Quarter;
        if (ascii.eqlIgnoreCase(value, @tagName(.Eighth))) return .Eighth;

        if (std.fmt.parseInt(u32, value, 10)) |size| {
            return ScreenSize{ .Size = size };
        } else |_| {
            return null;
        }
    }
};

test "ScreenSize Parse" {
    try testing.expect(ScreenSize.parse("FULL").? == .Full);
    try testing.expect(ScreenSize.parse("HALF").? == .Half);
    try testing.expect(ScreenSize.parse("THIRD").? == .Third);
    try testing.expect(ScreenSize.parse("QUARTER").? == .Quarter);
    try testing.expect(ScreenSize.parse("EIGHTH").? == .Eighth);
    try testing.expect(ScreenSize.parse("10").?.Size == 10);
    try testing.expect(ScreenSize.parse("ZZZ") == null);
}

pub const DialogSize = struct {
    width: ?ScreenSize,
    height: ?ScreenSize,

    pub fn parse(value: []const u8) DialogSize {
        var iterator = std.mem.split(value, "x");

        var ret = DialogSize{
            .width = null,
            .height = null,
        };

        if (iterator.next()) |first_value| {
            ret.width = ScreenSize.parse(first_value);
        }

        if (iterator.next()) |second_value| {
            ret.height = ScreenSize.parse(second_value);
        }

        return ret;
    }

    pub fn toString(self: DialogSize, buffer: []u8) [:0]const u8 {
        return screenSizeToString(buffer, self.width, self.height);
    }

    pub fn screenSizeToString(buffer: []u8, width: ?ScreenSize, height: ?ScreenSize) [:0]const u8 {
        var fba = std.heap.FixedBufferAllocator.init(buffer);
        var allocator = &fba.allocator;

        var builder = std.ArrayList(u8).init(allocator);
        defer builder.deinit();

        const values: [2]?ScreenSize = .{ width, height };
        for (values) |item, i| {
            if (i > 0) builder.appendSlice("x") catch unreachable;

            if (item) |value| {
                if (value == .Size) {
                    var str = std.fmt.allocPrint(allocator, "{}", .{value.Size}) catch unreachable;
                    defer allocator.free(str);
                    builder.appendSlice(str) catch unreachable;
                } else {
                    for (@tagName(value)) |char| {
                        builder.append(ascii.toUpper(char)) catch unreachable;
                    }
                }
            }
        }

        return builder.toOwnedSliceSentinel(0) catch unreachable;
    }
};

test "DialogSize Parse" {
    try testing.expect(expectDialogSize("FULLxFULL", .Full, .Full));
    try testing.expect(expectDialogSize("QUARTERxQUARTER", .Quarter, .Quarter));
    try testing.expect(expectDialogSize("HALF", .Half, null));
    try testing.expect(expectDialogSize("HALFx", .Half, null));
    try testing.expect(expectDialogSize("xHALF", null, .Half));
    try testing.expect(expectDialogSize("10x20", ScreenSize{ .Size = 10 }, ScreenSize{ .Size = 20 }));
    try testing.expect(expectDialogSize("x", null, null));
    try testing.expect(expectDialogSize("", null, null));
}

test "DialogSize ToString" {
    var buffer: [128]u8 = undefined;
    try testing.expect(ascii.endsWithIgnoreCase(DialogSize.screenSizeToString(&buffer, .Full, .Full), "FULLxFULL"));
    try testing.expect(ascii.endsWithIgnoreCase(DialogSize.screenSizeToString(&buffer, .Quarter, .Quarter), "QUARTERxQUARTER"));
    try testing.expect(ascii.endsWithIgnoreCase(DialogSize.screenSizeToString(&buffer, .Half, null), "HALFx"));
    try testing.expect(ascii.endsWithIgnoreCase(DialogSize.screenSizeToString(&buffer, null, .Half), "xHALF"));
    try testing.expect(ascii.endsWithIgnoreCase(DialogSize.screenSizeToString(&buffer, ScreenSize{ .Size = 10 }, ScreenSize{ .Size = 20 }), "10x20"));
    try testing.expect(ascii.endsWithIgnoreCase(DialogSize.screenSizeToString(&buffer, null, null), "x"));
}

fn expectDialogSize(str: []const u8, width: ?ScreenSize, height: ?ScreenSize) bool {
    var dialog_size = DialogSize.parse(str);
    return std.meta.eql(dialog_size.width, width) and std.meta.eql(dialog_size.height, height);
}

pub const DialogPosX = union(enum(c_int)) { Left = c.IUP_LEFT, Center = c.IUP_CENTER, Right = c.IUP_RIGHT, MousePos = c.IUP_MOUSEPOS, Current = c.IUP_CURRENT, CenterParent = c.IUP_CENTERPARENT, LeftParent = c.IUP_LEFTPARENT, RightParent = c.IUP_RIGHTPARENT, Absolute: c_int };

pub const DialogPosY = union(enum(c_int)) { Top = c.IUP_TOP, Center = c.IUP_CENTER, Bottom = c.IUP_BOTTOM, MousePos = c.IUP_MOUSEPOS, CenterParent = c.IUP_CENTERPARENT, Current = c.IUP_CURRENT, TopParent = c.IUP_TOPPARENT, BottomParent = c.IUP_BOTTOMPARENT, Absolute: c_int };

pub const Margin = struct {
    horiz: i32,
    vert: i32,

    pub fn parse(value: [:0]const u8) Margin {
        const separator = 'x';
        var horiz: i32 = undefined;
        var vert: i32 = undefined;
        _ = c.iupStrToIntInt(c.toCStr(value), &horiz, &vert, separator);

        return .{ .horiz = horiz, .vert = vert };
    }

    pub fn toString(self: Margin, buffer: []u8) [:0]const u8 {
        return c.intIntToString(buffer, self.horiz, self.vert, 'x');
    }

    pub fn intIntToString(buffer: []u8, horiz: i32, vert: i32) [:0]const u8 {
        return c.intIntToString(buffer, horiz, vert, 'x');
    }
};

test "Margin Parse" {
    var margin: Margin = undefined;

    margin = Margin.parse("1x2");
    try testing.expect(margin.horiz == 1);
    try testing.expect(margin.vert == 2);
}

test "Margin ToString" {
    var buffer: [128]u8 = undefined;
    var margin: Margin = undefined;

    margin = Margin{ .horiz = 1, .vert = 2 };
    try testing.expect(std.mem.eql(u8, margin.toString(&buffer), "1x2"));
}

pub const Size = struct {
    width: ?i32,
    height: ?i32,

    pub fn parse(value: [:0]const u8) Size {
        const separator = 'x';
        var width: i32 = undefined;
        var height: i32 = undefined;
        var ret = c.iupStrToIntInt(c.toCStr(value), &width, &height, separator);

        if (ret == 0) {
            // No value
            return .{ .width = null, .height = null };
        } else if (ret == 2) {
            // Both values
            return .{ .width = width, .height = height };
        } else if (value[0] == separator) {
            // Just one value, starts with separator, means second value only
            return .{ .width = null, .height = height };
        } else {
            // Just one value, means first value only
            return .{ .width = width, .height = null };
        }
    }

    pub fn toString(self: Size, buffer: []u8) [:0]const u8 {
        return intIntToString(buffer, self.width, self.height);
    }

    pub fn intIntToString(buffer: []u8, width: ?i32, height: ?i32) [:0]const u8 {
        var fbs = std.io.fixedBufferStream(buffer);

        if (width) |value| {
            std.fmt.format(fbs.writer(), "{}", .{value}) catch unreachable;
        }

        if (width != null or height != null) {
            std.fmt.format(fbs.writer(), "x", .{}) catch unreachable;
        }

        if (height) |value| {
            std.fmt.format(fbs.writer(), "{}", .{value}) catch unreachable;
        }

        buffer[fbs.pos] = 0;
        return buffer[0..fbs.pos :0];
    }
};

test "Size Parse" {
    var size: Size = undefined;

    size = Size.parse("1x2");
    try testing.expect(size.width.? == 1);
    try testing.expect(size.height.? == 2);

    size = Size.parse("1x");
    try testing.expect(size.width.? == 1);
    try testing.expect(size.height == null);

    size = Size.parse("x2");
    try testing.expect(size.width == null);
    try testing.expect(size.height.? == 2);

    size = Size.parse("");
    try testing.expect(size.width == null);
    try testing.expect(size.height == null);
}

test "Size ToString" {
    var buffer: [128]u8 = undefined;
    var size: Size = undefined;

    size = Size{ .width = 1, .height = 2 };
    try testing.expect(std.mem.eql(u8, size.toString(&buffer), "1x2"));

    size = Size{ .width = 1, .height = null };
    try testing.expect(std.mem.eql(u8, size.toString(&buffer), "1x"));

    size = Size{ .width = null, .height = 2 };
    try testing.expect(std.mem.eql(u8, size.toString(&buffer), "x2"));

    size = Size{ .width = null, .height = null };
    try testing.expect(std.mem.eql(u8, size.toString(&buffer), ""));
}

pub const XYPos = struct {
    x: i32,
    y: i32,

    const Self = @This();

    pub fn parse(value: [:0]const u8, comptime separator: u8) Self {
        var x: i32 = undefined;
        var y: i32 = undefined;
        _ = c.iupStrToIntInt(c.toCStr(value), &x, &y, separator);

        return .{ .x = x, .y = y };
    }

    pub fn toString(self: Self, buffer: []u8, comptime separator: u8) [:0]const u8 {
        return c.intIntToString(buffer, self.x, self.y, separator);
    }

    pub fn intIntToString(buffer: []u8, x: i32, y: i32, comptime separator: u8) [:0]const u8 {
        return c.intIntToString(buffer, x, y, separator);
    }
};

test "XYPos Parse" {
    var pos: XYPos = undefined;

    pos = XYPos.parse("1x2", 'x');
    try testing.expect(pos.x == 1);
    try testing.expect(pos.y == 2);

    pos = XYPos.parse("1,2", ',');
    try testing.expect(pos.x == 1);
    try testing.expect(pos.y == 2);

    pos = XYPos.parse("1:2", ':');
    try testing.expect(pos.x == 1);
    try testing.expect(pos.y == 2);

    pos = XYPos.parse("1;2", ';');
    try testing.expect(pos.x == 1);
    try testing.expect(pos.y == 2);
}

test "XYPos ToString" {
    var buffer: [128]u8 = undefined;
    var pos: XYPos = undefined;

    pos = XYPos{ .x = 1, .y = 2 };
    try testing.expect(std.mem.eql(u8, pos.toString(&buffer, 'x'), "1x2"));
    try testing.expect(std.mem.eql(u8, pos.toString(&buffer, ','), "1,2"));
    try testing.expect(std.mem.eql(u8, pos.toString(&buffer, ';'), "1;2"));
    try testing.expect(std.mem.eql(u8, pos.toString(&buffer, ':'), "1:2"));
}

pub const LinColPos = struct {
    lin: i32,
    col: i32,

    const Self = @This();

    pub fn parse(value: [:0]const u8, comptime separator: u8) Self {
        var lin: i32 = undefined;
        var col: i32 = undefined;
        _ = c.iupStrToIntInt(c.toCStr(value), &lin, &col, separator);

        return .{ .col = col, .lin = lin };
    }

    pub fn toString(self: Self, buffer: []u8, comptime separator: u8) [:0]const u8 {
        return c.intIntToString(buffer, self.lin, self.col, separator);
    }

    pub fn intIntToString(buffer: []u8, x: i32, y: i32, comptime separator: u8) [:0]const u8 {
        return c.intIntToString(buffer, x, y, separator);
    }
};

test "LinColPos Parse" {
    var pos: LinColPos = undefined;

    pos = LinColPos.parse("1x2", 'x');
    try testing.expect(pos.lin == 1);
    try testing.expect(pos.col == 2);

    pos = LinColPos.parse("1,2", ',');
    try testing.expect(pos.lin == 1);
    try testing.expect(pos.col == 2);

    pos = LinColPos.parse("1:2", ':');
    try testing.expect(pos.lin == 1);
    try testing.expect(pos.col == 2);

    pos = LinColPos.parse("1;2", ';');
    try testing.expect(pos.lin == 1);
    try testing.expect(pos.col == 2);
}

test "LinColPos ToString" {
    var buffer: [128]u8 = undefined;
    var pos: LinColPos = undefined;

    pos = LinColPos{ .lin = 1, .col = 2 };
    try testing.expect(std.mem.eql(u8, pos.toString(&buffer, 'x'), "1x2"));
    try testing.expect(std.mem.eql(u8, pos.toString(&buffer, ','), "1,2"));
    try testing.expect(std.mem.eql(u8, pos.toString(&buffer, ';'), "1;2"));
    try testing.expect(std.mem.eql(u8, pos.toString(&buffer, ':'), "1:2"));
}

pub const Range = struct {
    begin: i32,
    end: i32,

    const Self = @This();

    pub fn parse(value: [:0]const u8, comptime separator: u8) Self {
        var begin: i32 = undefined;
        var end: i32 = undefined;
        _ = c.iupStrToIntInt(c.toCStr(value), &begin, &end, separator);

        return .{ .begin = begin, .end = end };
    }

    pub fn toString(self: Self, buffer: []u8, comptime separator: u8) [:0]const u8 {
        return c.intIntToString(buffer, self.begin, self.end, separator);
    }

    pub fn intIntToString(buffer: []u8, begin: i32, end: i32, comptime separator: u8) [:0]const u8 {
        return c.intIntToString(buffer, begin, end, separator);
    }
};

test "Range Parse" {
    var range: Range = undefined;

    range = Range.parse("1x2", 'x');
    try testing.expect(range.begin == 1);
    try testing.expect(range.end == 2);

    range = Range.parse("1,2", ',');
    try testing.expect(range.begin == 1);
    try testing.expect(range.end == 2);

    range = Range.parse("1:2", ':');
    try testing.expect(range.begin == 1);
    try testing.expect(range.end == 2);

    range = Range.parse("1;2", ';');
    try testing.expect(range.begin == 1);
    try testing.expect(range.end == 2);
}

test "Range ToString" {
    var buffer: [128]u8 = undefined;
    var range: Range = undefined;

    range = Range{ .begin = 1, .end = 2 };
    try testing.expect(std.mem.eql(u8, range.toString(&buffer, 'x'), "1x2"));
    try testing.expect(std.mem.eql(u8, range.toString(&buffer, ','), "1,2"));
    try testing.expect(std.mem.eql(u8, range.toString(&buffer, ';'), "1;2"));
    try testing.expect(std.mem.eql(u8, range.toString(&buffer, ':'), "1:2"));
}

pub const Date = struct {
    year: u16,
    month: u8,
    day: u8,

    const Self = @This();

    pub fn parse(value: [:0]const u8) ?Self {
        var year: ?u16 = null;
        var month: ?u16 = null;
        var day: ?u16 = null;

        var iterator = std.mem.split(value, "/");

        for ([3]*?u16{ &year, &month, &day }) |ref| {
            if (iterator.next()) |part| {
                if (std.fmt.parseInt(u16, part, 10)) |int| {
                    ref.* = int;
                } else |_| {
                    break;
                }
            }
        }

        if (year != null and
            month != null and
            day != null)
        {
            return Self{
                .year = year.?,
                .month = @intCast(u8, month.?),
                .day = @intCast(u8, day.?),
            };

        } else {
            return null;
        }
    }

    pub fn toString(self: Self, buffer: []u8) [:0]const u8 {
        var fbs = std.io.fixedBufferStream(buffer);
        std.fmt.format(fbs.writer(), "{}/{}/{}\x00", .{ self.year, self.month, self.day }) catch unreachable;
        return buffer[0 .. fbs.pos - 1 :0];
    }    
};

test "Date Parse" {

    var date = Date.parse("2015/04/03") orelse unreachable;
    try testing.expect(date.year == 2015);
    try testing.expect(date.month == 4);
    try testing.expect(date.day == 3);

    try testing.expect(Date.parse("bad/1/1") == null);

    try testing.expect(Date.parse("") == null);
}

test "Date ToString" {
    var buffer: [128]u8 = undefined;
    var date: Date = undefined;

    date = Date{ .year = 2025, .month = 12, .day = 5 };
    try testing.expect(std.mem.eql(u8, date.toString(&buffer), "2025/12/5"));
}

pub const Rgb = struct {
    r: u8,
    g: u8,
    b: u8,
    a: ?u8 = null,      
};
