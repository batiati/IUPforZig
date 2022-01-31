/// CRUD
/// Challenges: separating the domain and presentation logic, managing mutation, building a non-trivial layout.
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

    var crud = try Crud.init(gpa.allocator());
    defer crud.deinit();

    try crud.show();
    try iup.MainLoop.beginLoop();
}

// Data model
const Person = struct {
    name: [:0]const u8,
    surname: [:0]const u8,

    pub fn copy(allocator: Allocator, name: []const u8, surname: []const u8) !Person {
        return Person{
            .name = try allocator.dupeZ(u8, name),
            .surname = try allocator.dupeZ(u8, surname),
        };
    }

    pub fn free(self: *Person, allocator: Allocator) void {
        allocator.free(self.name);
        allocator.free(self.surname);
    }

    pub fn fullNameOwned(self: Person, allocator: Allocator) ![:0]const u8 {
        return try std.fmt.allocPrintZ(allocator, "{s}, {s}", .{ self.surname, self.name });
    }
};

/// A simple datasource capable of Load/Add/Update/Delete/Filter
const DataSource = struct {
    const Self = @This();
    const PersonIndex = struct {
        index: usize,
        person: Person,
    };

    list: std.ArrayList(Person),
    filtred_entries: ?std.MultiArrayList(PersonIndex),

    pub fn init(allocator: Allocator) !Self {
        var self = Self{
            .list = std.ArrayList(Person).init(allocator),
            .filtred_entries = null,
        };

        return self;
    }

    pub fn deinit(self: *Self) void {
        self.clearFilter();

        const allocator = self.list.allocator;
        for (self.list.items) |*person| {
            person.free(allocator);
        }

        self.list.deinit();
    }

    pub fn loadInitialData(self: *Self) !void {
        self.clearFilter();
        self.list.clearAndFree();

        const allocator = self.list.allocator;
        try self.list.append(try Person.copy(allocator, "Hans", "Emil"));
        try self.list.append(try Person.copy(allocator, "Max", "Mustermann"));
        try self.list.append(try Person.copy(allocator, "Roman", "Tisch"));
    }

    pub fn filter(self: *Self, filter_text: ?[:0]const u8) !void {
        self.clearFilter();
        if (filter_text == null or filter_text.?.len == 0) return;

        const allocator = self.list.allocator;
        var current_filter = std.MultiArrayList(PersonIndex){};

        for (self.list.items) |person, i| {
            if (std.ascii.startsWithIgnoreCase(person.name, filter_text.?) or std.ascii.startsWithIgnoreCase(person.surname, filter_text.?)) {
                try current_filter.append(allocator, .{ .index = i, .person = person });
            }
        }

        self.filtred_entries = current_filter;
    }

    pub fn items(self: *Self) []Person {
        if (self.filtred_entries) |current_filter| {
            return current_filter.items(.person);
        } else {
            return self.list.items;
        }
    }

    pub fn get(self: *Self, element: usize) ?Person {
        var index = self.getIndexFromFilter(element);
        if (index >= self.list.items.len) return null;

        return self.list.items[index];
    }

    pub fn create(self: *Self, name: [:0]const u8, surname: [:0]const u8) !void {
        const allocator = self.list.allocator;
        var person = try Person.copy(allocator, name, surname);
        try self.list.append(person);
    }

    pub fn update(self: *Self, element: usize, name: [:0]const u8, surname: [:0]const u8) !void {
        var index = self.getIndexFromFilter(element);
        if (index >= self.list.items.len) return;

        const allocator = self.list.allocator;
        var person = &self.list.items[index];
        person.free(allocator);

        person.* = try Person.copy(allocator, name, surname);
    }

    pub fn delete(self: *Self, element: usize) !void {
        var index = self.getIndexFromFilter(element);
        if (index >= self.list.items.len) return;

        const allocator = self.list.allocator;
        var person = self.list.swapRemove(index);
        person.free(allocator);

        self.clearFilter();
    }

    fn getIndexFromFilter(self: *Self, index: usize) usize {
        if (self.filtred_entries) |current_filter| {
            var indexes = current_filter.items(.index);
            return indexes[index];
        } else {
            return index;
        }
    }

    fn clearFilter(self: *Self) void {
        if (self.filtred_entries) |*current_filter| {
            const allocator = self.list.allocator;
            current_filter.deinit(allocator);

            self.filtred_entries = null;
        }
    }
};

const Crud = struct {
    const Self = @This();

    allocator: Allocator,
    data_source: DataSource,
    current_selection: ?usize = null,
    dialog: *iup.Dialog = undefined,
    filter_text: *iup.Text = undefined,
    name_text: *iup.Text = undefined,
    surname_text: *iup.Text = undefined,
    list_view: *iup.List = undefined,

    pub fn init(allocator: Allocator) !*Self {
        var self = try allocator.create(Self);

        self.* = .{
            .allocator = allocator,
            .data_source = try DataSource.init(allocator),
        };

        try self.createDialog();
        return self;
    }

    pub fn deinit(self: *Self) void {
        self.dialog.deinit();
        self.data_source.deinit();
        self.allocator.destroy(self);
    }

    pub fn show(self: *Self) !void {
        try self.dialog.showXY(.Center, .Center);
        try self.data_source.loadInitialData();
        try self.refreshList();
    }

    fn createDialog(self: *Self) !void {
        self.dialog = try iup.Dialog.init()
            .setPtrAttribute(Self, "parent", self)
            .setTitle("CRUD")
            .setSize(.Quarter, .Half)
            .setChildren(
            .{
                iup.VBox.init()
                    .setExpandChildren(true)
                    .setMargin(10, 10)
                    .setGap(10)
                    .setChildren(
                    .{
                        iup.GridBox.init()
                            .setNormalizeSize(.Horizontal)
                            .setOrientation(.Horizontal)
                            .setNumDiv(2)
                            .setChildren(
                            .{
                                iup.HBox.init()
                                    .setChildren(
                                    .{
                                        iup.Label.init()
                                            .setTitle("Filter prefix:"),
                                        iup.Text.init()
                                            .capture(&self.filter_text)
                                            .setValueChangedCallback(onFilter),
                                    },
                                ),
                                iup.Fill.init(),
                                iup.List.init()
                                    .capture(&self.list_view)
                                    .setActionCallback(onSelected)
                                    .setExpand(.Yes),
                                iup.GridBox.init()
                                    .setGapLin(20)
                                    .setNormalizeSize(.Horizontal)
                                    .setOrientation(.Horizontal)
                                    .setNumDiv(2)
                                    .setChildren(
                                    .{
                                        iup.Label.init()
                                            .setTitle("Name:"),
                                        iup.Text.init()
                                            .capture(&self.name_text),
                                        iup.Label.init()
                                            .setTitle("Surname:"),
                                        iup.Text.init()
                                            .capture(&self.surname_text),
                                    },
                                ),
                            },
                        ),
                        iup.HBox.init()
                            .setAlignment(.ACenter)
                            .setChildren(
                            .{
                                iup.Button.init()
                                    .setActionCallback(onCreate)
                                    .setTitle("Create"),
                                iup.Button.init()
                                    .setActionCallback(onUpdate)
                                    .setTitle("Update"),
                                iup.Button.init()
                                    .setActionCallback(onDelete)
                                    .setTitle("Delete"),
                            },
                        ),
                    },
                ),
            },
        ).unwrap();
    }

    fn onFilter(text: *iup.Text) !void {
        var dialog = text.getDialog() orelse unreachable;
        var self = dialog.getPtrAttribute(Self, "parent") orelse @panic("Parent struct not set!");

        try self.refreshList();
    }

    fn onSelected(list: *iup.List, text: [:0]const u8, row: i32, col: i32) !void {
        _ = text;
        _ = col;
        if (row <= 0) return;

        var dialog = list.getDialog() orelse unreachable;
        var self = dialog.getPtrAttribute(Self, "parent") orelse @panic("Parent struct not set!");

        const index = @intCast(usize, row - 1);
        try self.edit(index);
    }

    fn onCreate(button: *iup.Button) !void {
        var dialog = button.getDialog() orelse unreachable;
        var self = dialog.getPtrAttribute(Self, "parent") orelse @panic("Parent struct not set!");

        try self.create();
    }

    fn onUpdate(button: *iup.Button) !void {
        var dialog = button.getDialog() orelse unreachable;
        var self = dialog.getPtrAttribute(Self, "parent") orelse @panic("Parent struct not set!");

        try self.update();
    }

    fn onDelete(button: *iup.Button) !void {
        var dialog = button.getDialog() orelse unreachable;
        var self = dialog.getPtrAttribute(Self, "parent") orelse @panic("Parent struct not set!");

        try self.delete();
    }

    fn edit(self: *Self, index: usize) !void {
        if (self.data_source.get(index)) |person| {
            self.current_selection = index;
            self.name_text.setValue(person.name);
            self.surname_text.setValue(person.surname);
        }
    }

    fn update(self: *Self) !void {
        if (self.current_selection) |index| {
            try self.data_source.update(index, self.name_text.getValue(), self.surname_text.getValue());
            try self.refreshList();
        }
    }

    fn delete(self: *Self) !void {
        if (self.current_selection) |index| {
            try self.data_source.delete(index);
            try self.refreshList();
        }
    }

    fn create(self: *Self) !void {
        try self.data_source.create(self.name_text.getValue(), self.surname_text.getValue());
        try self.refreshList();
    }

    fn refreshList(self: *Self) !void {
        self.list_view.removeItem(null);
        self.name_text.setValue("");
        self.surname_text.setValue("");

        try self.data_source.filter(self.filter_text.getValue());

        for (self.data_source.items()) |person| {
            var full_name = try person.fullNameOwned(self.allocator);
            defer self.allocator.free(full_name);
            self.list_view.appendItem(full_name);
        }
    }
};
