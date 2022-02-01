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
    id: i32,
    name: [:0]const u8,
    surname: [:0]const u8,

    pub fn copy(allocator: Allocator, id: i32, name: []const u8, surname: []const u8) !Person {
        return Person{
            .id = id,
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
    const PersonList = std.AutoArrayHashMap(i32, Person);

    list: PersonList,
    sequence: i32 = 0,

    pub fn init(allocator: Allocator) !Self {
        var self = Self{
            .list = PersonList.init(allocator),
        };

        return self;
    }

    pub fn deinit(self: *Self) void {
        const allocator = self.list.allocator;
        for (self.list.values()) |*person| {
            person.free(allocator);
        }

        self.list.deinit();
    }

    pub fn loadInitialData(self: *Self) !void {
        self.sequence = 0;
        self.list.clearAndFree();

        try self.create("Hans", "Emil");
        try self.create("Max", "Mustermann");
        try self.create("Roman", "Tisch");
    }

    pub fn get(self: *Self, id: i32) ?Person {
        return self.list.get(id);
    }

    pub fn create(self: *Self, name: [:0]const u8, surname: [:0]const u8) !void {
        const allocator = self.list.allocator;

        self.sequence += 1;
        var person = try Person.copy(allocator, self.sequence, name, surname);
        try self.list.put(person.id, person);
    }

    pub fn update(self: *Self, id: i32, name: [:0]const u8, surname: [:0]const u8) !void {
        var person = self.list.getPtr(id) orelse return;

        const allocator = self.list.allocator;
        person.free(allocator);

        person.* = try Person.copy(allocator, id, name, surname);
    }

    pub fn delete(self: *Self, id: i32) void {
        var kv = self.list.fetchSwapRemove(id) orelse return;

        const allocator = self.list.allocator;
        kv.value.free(allocator);
    }

    pub const FilterIterator = struct {
        index: usize = 0,
        slice: []Person,
        filter_text: ?[:0]const u8,

        pub fn next(self: *@This()) ?Person {
            if (self.index < self.slice.len) {
                for (self.slice[self.index..]) |person| {
                    self.index += 1;
                    if (self.filter_text == null or std.ascii.startsWithIgnoreCase(person.name, self.filter_text.?) or std.ascii.startsWithIgnoreCase(person.surname, self.filter_text.?)) {
                        return person;
                    }
                }
            }

            return null;
        }
    };

    pub fn filter(self: *Self, filter_text: ?[:0]const u8) FilterIterator {
        return .{
            .slice = self.list.values(),
            .filter_text = filter_text,
        };
    }
};

const Crud = struct {
    const Self = @This();

    allocator: Allocator,
    data_source: DataSource,
    current_selection: ?i32 = null,
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
                    .setMargin(10, 10)
                    .setChildren(
                    .{
                        iup.HBox.init()
                            .setChildren(
                            .{
                                iup.HBox.init()
                                    .setGap(10)
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
                            },
                        ),
                        iup.HBox.init()
                            .setAlignment(.ATop)
                            .setChildren(
                            .{
                                iup.List.init()
                                    .capture(&self.list_view)
                                    .setActionCallback(onSelected)
                                    .setExpand(.Yes),
                                iup.GridBox.init()
                                    .setGapLin(20)
                                    .setOrientation(.Horizontal)
                                    .setNumDiv(2)
                                    .setChildren(
                                    .{
                                        iup.Label.init()
                                            .setSize(40, null)
                                            .setTitle("Name:"),
                                        iup.Text.init()
                                            .setExpand(.Horizontal)
                                            .capture(&self.name_text),
                                        iup.Label.init()
                                            .setSize(40, null)
                                            .setTitle("Surname:"),
                                        iup.Text.init()
                                            .setExpand(.Horizontal)
                                            .capture(&self.surname_text),
                                    },
                                ),
                            },
                        ),
                        iup.HBox.init()
                            .setGap(10)
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

        const id = self.list_view.getIntId("id", row);
        try self.edit(id);
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

    fn edit(self: *Self, id: i32) !void {
        if (self.data_source.get(id)) |person| {
            self.current_selection = id;
            self.name_text.setValue(person.name);
            self.surname_text.setValue(person.surname);
        }
    }

    fn update(self: *Self) !void {
        if (self.current_selection) |id| {
            try self.data_source.update(id, self.name_text.getValue(), self.surname_text.getValue());
            try self.refreshList();
        }
    }

    fn delete(self: *Self) !void {
        if (self.current_selection) |id| {
            self.data_source.delete(id);
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

        var iterator = self.data_source.filter(self.filter_text.getValue());
        while (iterator.next()) |person| {
            var full_name = try person.fullNameOwned(self.allocator);
            defer self.allocator.free(full_name);

            self.list_view.appendItem(full_name);
            const row = self.list_view.getCount();
            self.list_view.setIntId("id", row, person.id);
        }
    }
};
