const std = @import("std");
const iup = @import("iup");
const Allocator = std.mem.Allocator;
const GeneralPurposeAllocator = std.heap.GeneralPurposeAllocator(.{});

pub fn main() anyerror!void {
    var gpa = GeneralPurposeAllocator{};
    defer _ = gpa.deinit();

    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var counter = try Counter.init(gpa.allocator(), 0);
    defer counter.deinit();

    try counter.show();
    try iup.MainLoop.beginLoop();
}

const Counter = struct {
    const Self = @This();

    counter: usize,
    allocator: Allocator,
    dialog: *iup.Dialog = undefined,
    counter_text: *iup.Text = undefined,

    pub fn init(allocator: Allocator, counter: usize) !*Self {
        var self = try allocator.create(Self);

        self.* = .{
            .counter = counter,
            .allocator = allocator,
        };

        try self.createDialog();
        try self.refreshCounter();

        return self;
    }

    pub fn deinit(self: *Self) void {
        self.dialog.deinit();
        self.allocator.destroy(self);
    }

    pub fn show(self: *Self) !void {
        try self.dialog.showXY(.Center, .Center);
    }

    fn createDialog(self: *Self) !void {
        self.dialog = try iup.Dialog.init()
            .setTitle("Counter")
            .setSize(iup.ScreenSize{ .Size = 120 }, iup.ScreenSize{ .Size = 40 })
            .setChildren(
            .{
                iup.HBox.init()
                    .setMargin(10, 10)
                    .setGap(10)
                    .setChildren(
                    .{
                        iup.Text.init()
                            .capture(&self.counter_text)
                            .setReadonly(true),
                        iup.Button.init()
                            .setPtrAttribute(Self, "parent", self)
                            .setTitle("Count")
                            .setActionCallback(onCount),
                    },
                ),
            },
        ).unwrap();
    }

    fn onCount(button: *iup.Button) !void {
        var self = button.getPtrAttribute(Self, "parent") orelse @panic("Parent struct not set!");
        self.counter += 1;

        try self.refreshCounter();
    }

    fn refreshCounter(self: *Self) !void {
        std.log.debug("refreshing counter {}", .{self.counter});

        var str = try std.fmt.allocPrintZ(self.allocator, "{}", .{self.counter});
        defer self.allocator.free(str);

        self.counter_text.setValue(str);
    }
};
