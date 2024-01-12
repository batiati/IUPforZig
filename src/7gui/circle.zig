/// Circle Drawer
/// Challenges: undo/redo, custom drawing, dialog control
/// https://eugenkiss.github.io/7guis/tasks
const std = @import("std");
const iup = @import("../iup.zig");
const Allocator = std.mem.Allocator;
const GeneralPurposeAllocator = std.heap.GeneralPurposeAllocator(.{});

const assert = std.debug.assert;

pub fn main() anyerror!void {
    var gpa = GeneralPurposeAllocator{};
    defer _ = gpa.deinit();

    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var circle_drawer = try CircleDrawer.init(gpa.allocator());
    defer circle_drawer.deinit();

    try circle_drawer.show();
    try iup.MainLoop.beginLoop();
}

const CircleDrawer = struct {
    const Self = @This();

    allocator: Allocator,
    drawing: Drawing,
    dialog: *iup.Dialog = undefined,
    canvas: *iup.Canvas = undefined,
    redo_button: *iup.Button = undefined,
    undo_button: *iup.Button = undefined,

    pub fn init(allocator: Allocator) !*Self {
        var self = try allocator.create(Self);

        self.* = .{
            .allocator = allocator,
            .drawing = try Drawing.init(allocator),
        };

        try self.createDialog();
        return self;
    }

    pub fn deinit(self: *Self) void {
        self.dialog.deinit();
        self.drawing.deinit();
        self.allocator.destroy(self);
    }

    pub fn show(self: *Self) !void {
        try self.dialog.showXY(.Center, .Center);
        self.updateButtons();
    }

    fn createDialog(self: *Self) !void {
        self.dialog = try iup.Dialog.init()
            .setPtrAttribute(Self, "parent", self)
            .setTitle("Circle Drawer")
            .setSize(iup.ScreenSize{ .Size = 500 }, iup.ScreenSize{ .Size = 300 })
            .setChildren(
            .{
                iup.VBox.init()
                    .setMargin(10, 10)
                    .setGap(10)
                    .setChildren(
                    .{
                        iup.HBox.init()
                            .setMargin(10, 10)
                            .setAlignment(.ACenter)
                            .setChildren(
                            .{
                                iup.Fill.init(),
                                iup.Button.init()
                                    .setActionCallback(onAction)
                                    .capture(&self.undo_button)
                                    .setSize(60, null)
                                    .setTitle("Undo"),
                                iup.Button.init()
                                    .setActionCallback(onAction)
                                    .capture(&self.redo_button)
                                    .setSize(60, null)
                                    .setTitle("Redo"),
                                iup.Fill.init(),
                            },
                        ),
                        iup.Canvas.init()
                            .setButtonCallback(onClick)
                            .setActionCallback(onPaint)
                            .capture(&self.canvas)
                            .setExpand(.Yes),
                    },
                ),
            },
        ).unwrap();
    }

    fn onClick(canvas: *iup.Canvas, button: i32, pressed: i32, x: i32, y: i32, status: [:0]const u8) !void {
        _ = status;

        if (pressed == 0) return;

        var dialog = canvas.getDialog() orelse unreachable;
        var self = dialog.getPtrAttribute(Self, "parent") orelse @panic("Parent struct not set!");

        if (button == iup.mouse.BUTTON_1) {
            if (self.drawing.getCollision(x, y)) |id| {
                self.drawing.setSelected(id, true);
            } else {
                try self.drawing.create(x, y);
            }

            canvas.update();
        } else if (button == iup.mouse.BUTTON_3) {
            if (self.drawing.getCollision(x, y)) |id| {
                self.drawing.setSelected(id, false);
                canvas.update();

                var config = try ConfigDialog.init(self);
                defer config.deinit();

                try config.show();
            }
        }

        self.updateButtons();
    }

    fn onPaint(canvas: *iup.Canvas, x: f32, y: f32) !void {
        _ = x;
        _ = y;

        var dialog = canvas.getDialog() orelse unreachable;
        var self = dialog.getPtrAttribute(Self, "parent") orelse @panic("Parent struct not set!");

        canvas.drawBegin();
        defer canvas.drawEnd();

        const size = canvas.drawGetSize();

        canvas.setDrawColor(.{ .r = 255, .g = 255, .b = 255 });
        canvas.setDrawStyle(.Fill);
        canvas.drawRectangle(0, 0, size.width - 1, size.height - 1);

        for (self.drawing.items()) |circle| {
            if (circle.id == self.drawing.selected) {
                canvas.setDrawColor(.{ .r = 128, .g = 128, .b = 128 });
                canvas.setDrawStyle(.Fill);
            } else {
                canvas.setDrawColor(.{ .r = 0, .g = 0, .b = 0 });
                canvas.setDrawStyle(.DrawStroke);
            }

            canvas.drawArc(
                circle.x - circle.radius,
                circle.y - circle.radius,
                circle.x + circle.radius,
                circle.y + circle.radius,
                0.0,
                360.0,
            );
        }
    }

    fn onAction(button: *iup.Button) !void {
        var dialog = button.getDialog() orelse unreachable;
        var self = dialog.getPtrAttribute(Self, "parent") orelse @panic("Parent struct not set!");

        if (button == self.undo_button) {
            try self.drawing.undo();
        } else if (button == self.redo_button) {
            try self.drawing.redo();
        }

        self.canvas.update();
        self.updateButtons();
    }

    fn updateButtons(self: *Self) void {
        self.undo_button.setActive(self.drawing.canUndo());
        self.redo_button.setActive(self.drawing.canRedo());
    }

    pub fn updateRadius(self: *Self, id: u32, old_radius: i32, new_radius: i32) !void {
        try self.drawing.update(id, old_radius, new_radius);
        self.canvas.update();
    }

    pub fn previewRadius(self: *Self, id: u32, new_radius: i32) !void {
        try self.drawing.setRadius(id, new_radius);
        self.canvas.update();
    }
};

const ConfigDialog = struct {
    const Self = @This();

    parent: *CircleDrawer,
    editing_circle: ?Circle = null,
    dialog: *iup.Dialog = undefined,
    label: *iup.Label = undefined,
    val: *iup.Val = undefined,

    pub fn init(parent: *CircleDrawer) !*Self {
        const allocator = parent.allocator;
        var self = try allocator.create(Self);

        self.* = .{
            .parent = parent,
        };

        try self.createDialog();
        return self;
    }

    pub fn deinit(self: *Self) void {
        self.dialog.deinit();

        const allocator = self.parent.allocator;
        allocator.destroy(self);
    }

    pub fn show(self: *Self) !void {
        const circle = self.parent.drawing.getSelected() orelse return;
        const allocator = self.parent.allocator;

        var label_text = try std.fmt.allocPrintZ(allocator, "Adjust diameter of the circle at ({}, {})", .{ circle.x, circle.y });
        defer allocator.free(label_text);

        self.editing_circle = circle;
        self.label.setTitle(label_text);
        self.val.setValue(@as(f64, @floatFromInt(self.editing_circle.?.radius)));

        try self.dialog.popup(.CenterParent, .CenterParent);
    }

    fn createDialog(self: *Self) !void {
        self.dialog = try iup.Dialog.init()
            .setParentDialog(self.parent.dialog)
            .setPtrAttribute(Self, "parent", self)
            .setTitle("Circle Diameter")
            .setDialogFrame(false)
            .setMinBox(false)
            .setMaxBox(false)
            .setResize(false)
            .setToolBox(true)
            .setCloseCallback(onClose)
            .setChildren(
            .{
                iup.VBox.init()
                    .setAlignment(.ACenter)
                    .setMargin(10, 10)
                    .setGap(10)
                    .setChildren(
                    .{
                        iup.Label.init()
                            .capture(&self.label)
                            .setExpand(.Horizontal),
                        iup.Val.init()
                            .capture(&self.val)
                            .setMin(Circle.MinRadius)
                            .setMax(Circle.MaxRadius)
                            .setValueChangedCallback(onValueChanged)
                            .setExpand(.Horizontal),
                    },
                ),
            },
        ).unwrap();
    }

    fn onValueChanged(val: *iup.Val) !void {
        var dialog = val.getDialog() orelse unreachable;
        var self = dialog.getPtrAttribute(Self, "parent") orelse @panic("Parent struct not set!");

        if (self.editing_circle) |circle| {
            const new_radius = @as(i32, @intFromFloat(self.val.getValue()));
            try self.parent.previewRadius(circle.id, new_radius);
        }
    }

    fn onClose(dialog: *iup.Dialog) !void {
        var self = dialog.getPtrAttribute(Self, "parent") orelse @panic("Parent struct not set!");

        if (self.editing_circle) |circle| {
            const new_radius = @as(i32, @intFromFloat(self.val.getValue()));
            if (circle.radius == new_radius) return;

            try self.parent.updateRadius(circle.id, circle.radius, new_radius);
        }
    }
};

const Circle = struct {
    const Self = @This();

    pub const DefaultRadius = 30;
    pub const MinRadius = 5;
    pub const MaxRadius = 120;

    id: u32,
    x: i32,
    y: i32,
    radius: i32,

    pub fn collision(self: Self, x: i32, y: i32) ?i32 {
        const dx = self.x - x;
        const dy = self.y - y;
        const r = @as(i32, @intFromFloat(std.math.sqrt(@as(f64, @floatFromInt(dx * dx + dy * dy)))));

        return if (r < self.radius) r else null;
    }

    test "collision" {
        var self = Self{
            .id = 0,
            .x = 100,
            .y = 100,
            .radius = 20,
        };

        const distance = @as(i32, 7);
        try std.testing.expectEqual(distance, self.collision(105, 105).?);
        try std.testing.expectEqual(distance, self.collision(95, 105).?);
        try std.testing.expectEqual(distance, self.collision(105, 95).?);
        try std.testing.expectEqual(distance, self.collision(95, 95).?);
        try std.testing.expect(self.collision(150, 150) == null);
    }
};

/// Simple DataSource to store all circles perform the undo/redo history.
const Drawing = struct {
    const Self = @This();

    const Action = union(enum) {
        Create: Circle,
        Update: struct { id: u32, old_radius: i32, new_radius: i32 },
    };

    sequence: u32,
    selected: ?u32,
    circles: std.AutoArrayHashMap(u32, Circle),
    undo_history: std.ArrayList(Action),
    undo_index: ?usize,

    pub fn init(allocator: Allocator) !Self {
        return Self{
            .sequence = 0,
            .selected = null,
            .circles = std.AutoArrayHashMap(u32, Circle).init(allocator),
            .undo_history = std.ArrayList(Action).init(allocator),
            .undo_index = null,
        };
    }

    pub fn deinit(self: *Self) void {
        self.circles.deinit();
        self.undo_history.deinit();
    }

    pub fn canUndo(self: *const Self) bool {
        return self.undo_history.items.len > 0 and (self.undo_index == null or self.undo_index.? > 0);
    }

    pub fn canRedo(self: *const Self) bool {
        return self.undo_history.items.len > 0 and self.undo_index != null;
    }

    pub fn getCircleById(self: *const Self, id: u32) ?Circle {
        return self.circles.get(id);
    }

    pub fn getSelected(self: *const Self) ?Circle {
        const id = self.selected orelse return null;
        return self.getCircleById(id);
    }

    pub fn setSelected(self: *Self, id: ?u32, toggle: bool) void {
        if (toggle and std.meta.eql(self.selected, id)) {
            self.selected = null;
        } else {
            self.selected = id;
        }
    }

    pub fn getCollision(self: *const Self, x: i32, y: i32) ?u32 {
        var id: ?u32 = null;
        var min_distance: ?i32 = null;

        for (self.circles.values()) |*circle| {
            if (circle.collision(x, y)) |distance| {
                if (min_distance == null or distance < min_distance.?) {
                    min_distance = distance;
                    id = circle.id;
                }
            }
        }

        return id;
    }

    pub fn items(self: *const Self) []Circle {
        return self.circles.values();
    }

    pub fn create(self: *Self, x: i32, y: i32) !void {
        self.sequence += 1;
        var circle = Circle{
            .id = self.sequence,
            .x = x,
            .y = y,
            .radius = Circle.DefaultRadius,
        };

        try self.invalidateRedoHistory();
        try self.undo_history.append(.{ .Create = circle });

        try self.addCircle(circle);
    }

    pub fn update(self: *Self, id: u32, old_radius: i32, new_radius: i32) !void {
        try self.invalidateRedoHistory();
        try self.undo_history.append(.{ .Update = .{ .id = id, .old_radius = old_radius, .new_radius = new_radius } });

        try self.setRadius(id, new_radius);
    }

    pub fn setRadius(self: *Self, id: u32, radius: i32) !void {
        var circle = self.circles.getPtr(id) orelse return;
        circle.radius = radius;
    }

    fn addCircle(self: *Self, circle: Circle) !void {
        try self.circles.put(circle.id, circle);
        self.selected = null;
    }

    fn removeCircle(self: *Self, id: u32) void {
        _ = self.circles.swapRemove(id);
    }

    pub fn undo(self: *Self) !void {
        self.undo_index = blk: {
            if (self.undo_index) |undo_index| {
                if (undo_index == 0) return;
                assert(undo_index < self.undo_history.items.len);
                break :blk undo_index - 1;
            } else {
                break :blk self.undo_history.items.len - 1;
            }
        };

        const action = self.undo_history.items[self.undo_index.?];

        switch (action) {
            .Create => |circle| self.removeCircle(circle.id),
            .Update => |change| try self.setRadius(change.id, change.old_radius),
        }
    }

    pub fn redo(self: *Self) !void {
        if (self.undo_index) |undo_index| {
            assert(undo_index < self.undo_history.items.len);

            const action = self.undo_history.items[undo_index];
            self.undo_index = if (undo_index == self.undo_history.items.len - 1) null else undo_index + 1;

            switch (action) {
                .Create => |circle| try self.addCircle(circle),
                .Update => |change| try self.setRadius(change.id, change.new_radius),
            }
        }
    }

    pub fn invalidateRedoHistory(self: *Self) !void {
        if (self.undo_index) |undo_index| {
            assert(undo_index < self.undo_history.items.len);

            self.undo_history.shrinkRetainingCapacity(undo_index);
            self.undo_index = null;
        }
    }

    test "create circle" {
        const allocator = std.testing.allocator;
        var self = try Self.init(allocator);
        defer self.deinit();

        try std.testing.expect(self.items().len == 0);
        try std.testing.expectEqual(false, self.canUndo());
        try std.testing.expectEqual(false, self.canRedo());

        try self.create(100, 100);
        try std.testing.expect(self.items().len == 1);
        try std.testing.expectEqual(true, self.canUndo());
        try std.testing.expectEqual(false, self.canRedo());

        try self.create(200, 200);
        try std.testing.expect(self.items().len == 2);
        try std.testing.expectEqual(true, self.canUndo());
        try std.testing.expectEqual(false, self.canRedo());

        try self.undo();
        try std.testing.expect(self.items().len == 1);
        try std.testing.expectEqual(true, self.canUndo());
        try std.testing.expectEqual(true, self.canRedo());

        try self.undo();
        try std.testing.expect(self.items().len == 0);
        try std.testing.expectEqual(false, self.canUndo());
        try std.testing.expectEqual(true, self.canRedo());

        try self.redo();
        try std.testing.expect(self.items().len == 1);
        try std.testing.expectEqual(true, self.canUndo());
        try std.testing.expectEqual(true, self.canRedo());

        try self.redo();
        try std.testing.expect(self.items().len == 2);
        try std.testing.expectEqual(true, self.canUndo());
        try std.testing.expectEqual(false, self.canRedo());
    }

    test "update radius" {
        const allocator = std.testing.allocator;
        var self = try Self.init(allocator);
        defer self.deinit();

        try self.create(100, 100);
        const circle = self.items()[0];

        try self.update(circle.id, circle.radius, circle.radius + 10);
        try std.testing.expectEqual(true, self.canUndo());
        try std.testing.expectEqual(false, self.canRedo());
        try std.testing.expectEqual(circle.radius + 10, self.getCircleById(circle.id).?.radius);

        try self.undo();
        try std.testing.expectEqual(true, self.canUndo());
        try std.testing.expectEqual(true, self.canRedo());
        try std.testing.expectEqual(circle.radius, self.getCircleById(circle.id).?.radius);

        try self.redo();
        try std.testing.expectEqual(true, self.canUndo());
        try std.testing.expectEqual(false, self.canRedo());
        try std.testing.expectEqual(circle.radius + 10, self.getCircleById(circle.id).?.radius);
    }

    test "invalidate redo list" {
        const allocator = std.testing.allocator;
        var self = try Self.init(allocator);
        defer self.deinit();

        try self.create(100, 100);
        try std.testing.expectEqual(true, self.canUndo());
        try std.testing.expectEqual(false, self.canRedo());

        try self.undo();
        try std.testing.expectEqual(false, self.canUndo());
        try std.testing.expectEqual(true, self.canRedo());

        try self.create(101, 101);
        try std.testing.expectEqual(true, self.canUndo());
        try std.testing.expectEqual(false, self.canRedo());
    }
};
