/// Timer
/// Challenges: concurrency, competing user/signal interactions, responsiveness.
/// https://eugenkiss.github.io/7guis/tasks
const std = @import("std");
const iup = @import("../iup.zig");
const Allocator = std.mem.Allocator;
const GeneralPurposeAllocator = std.heap.GeneralPurposeAllocator(.{});

pub fn main() anyerror!void {
    var gpa = GeneralPurposeAllocator{};
    defer _ = gpa.deinit();

    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var timer = try Timer.init(gpa.allocator(), 15);
    defer timer.deinit();

    try timer.show();
    try iup.MainLoop.beginLoop();
}

const Timer = struct {
    const Self = @This();

    duration: f64,
    allocator: Allocator,
    start_timestamp: i64 = undefined,
    dialog: *iup.Dialog = undefined,
    progress: *iup.Gauge = undefined,
    duration_label: *iup.Label = undefined,

    pub fn init(allocator: Allocator, duration: f64) !*Self {
        var self = try allocator.create(Self);

        self.* = .{
            .duration = duration,
            .allocator = allocator,
        };

        try self.createDialog();
        try self.refreshDuration();

        return self;
    }

    pub fn deinit(self: *Self) void {
        self.dialog.deinit();
        self.allocator.destroy(self);
    }

    pub fn show(self: *Self) !void {
        self.resetTimer();
        try self.dialog.showXY(.Center, .Center);
    }

    fn createDialog(self: *Self) !void {
        self.dialog = try iup.Dialog.init()
            .setPtrAttribute(Self, "parent", self)
            .setTitle("Timer")
            .setSize(iup.ScreenSize{ .Size = 250 }, iup.ScreenSize{ .Size = 140 })
            .setChildren(
            .{
                iup.VBox.init()
                    .setMargin(10, 10)
                    .setGap(10)
                    .setExpandChildren(true)
                    .setChildren(
                    .{
                        iup.GridBox.init()
                            .setGapCol(5)
                            .setOrientation(.Horizontal)
                            .setNumDiv(2)
                            .setExpandChildren(.Yes)
                            .setChildren(
                            .{
                                iup.Label.init()
                                    .setTitle("Elapsed time:"),
                                iup.Gauge.init()
                                    .capture(&self.progress)
                                    .setMin(0.1)
                                    .setMax(self.duration),
                                iup.Label.init()
                                    .capture(&self.duration_label),
                                iup.Fill.init(),
                                iup.Label.init()
                                    .setTitle("Duration:"),
                                iup.Val.init()
                                    .setValueChangedCallback(onDurationChanged)
                                    .setMin(0)
                                    .setMax(30)
                                    .setStep(0.1)
                                    .setValue(self.duration),
                            },
                        ),
                        iup.Button.init()
                            .setActionCallback(onReset)
                            .setTitle("Reset Timer"),
                        iup.Timer.init()
                            .setActionCallback(onTimer)
                            .setTime(100)
                            .setRun(true),
                    },
                ),
            },
        ).unwrap();
    }

    fn onDurationChanged(val: *iup.Val) !void {
        var dialog = val.getDialog() orelse unreachable;
        var self = dialog.getPtrAttribute(Self, "parent") orelse @panic("Parent struct not set!");
        self.duration = val.getValue();

        try self.refreshDuration();
    }

    fn onReset(button: *iup.Button) !void {
        var dialog = button.getDialog() orelse unreachable;
        var self = dialog.getPtrAttribute(Self, "parent") orelse @panic("Parent struct not set!");

        self.resetTimer();
    }

    fn onTimer(timer: *iup.Timer) !void {
        var dialog = timer.getDialog() orelse unreachable;
        var self = dialog.getPtrAttribute(Self, "parent") orelse @panic("Parent struct not set!");

        const elapsed_ms = std.time.milliTimestamp() - self.start_timestamp;
        const elapsed_s = @as(f64, @floatFromInt(elapsed_ms)) / @as(f64, std.time.ms_per_s);

        self.progress.setValue(elapsed_s);
    }

    fn resetTimer(self: *Self) void {
        self.start_timestamp = std.time.milliTimestamp();
    }

    fn refreshDuration(self: *Self) !void {
        var text = try std.fmt.allocPrintZ(self.allocator, "{d:.1}s", .{self.duration});
        defer self.allocator.free(text);

        self.duration_label.setTitle(text);
        self.progress.setMax(self.duration);
    }
};
