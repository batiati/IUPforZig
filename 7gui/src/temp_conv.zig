/// Temperature Converter
/// Challenges: bidirectional data flow, user-provided text input.
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

    var temp_conv = try TempConv.init(gpa.allocator());
    defer temp_conv.deinit();

    try temp_conv.show();
    try iup.MainLoop.beginLoop();
}

const TempConv = struct {
    const Self = @This();

    allocator: Allocator,
    dialog: *iup.Dialog = undefined,
    celsius_text: *iup.Text = undefined,
    fahrenheit_text: *iup.Text = undefined,

    pub fn init(allocator: Allocator) !*Self {
        var self = try allocator.create(Self);

        self.* = .{
            .allocator = allocator,
        };

        try self.createDialog();
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
            .setPtrAttribute(Self, "parent", self)
            .setTitle("TempConv")
            .setSize(iup.ScreenSize{ .Size = 220 }, iup.ScreenSize{ .Size = 40 })
            .setChildren(
            .{
                iup.HBox.init()
                    .setMargin(10, 10)
                    .setGap(10)
                    .setChildren(
                    .{
                        iup.Text.init()
                            .setActionCallback(onCelsiusChanged)
                            .setMask(iup.masks.float)
                            .capture(&self.celsius_text),
                        iup.Label.init()
                            .setTitle("Celsius = "),
                        iup.Text.init()
                            .setActionCallback(onFahrenheitChanged)
                            .setMask(iup.masks.float)
                            .capture(&self.fahrenheit_text),
                        iup.Label.init()
                            .setTitle("Fahrenheit"),
                    },
                ),
            },
        ).unwrap();
    }

    fn convertToFahrenheit(self: *Self, celsius_str: [:0]const u8) !void {
        std.log.debug("refreshing from celsius {s}", .{celsius_str});

        const celsius_value = std.fmt.parseFloat(f32, celsius_str) catch {
            self.fahrenheit_text.setValue("");
            return;
        };

        const fahrenheit_value = (celsius_value * (9.0 / 5.0)) + 32.0;
        var fahrenheit_str = try std.fmt.allocPrintZ(self.allocator, "{d:.2}", .{fahrenheit_value});
        defer self.allocator.free(fahrenheit_str);

        self.fahrenheit_text.setValue(fahrenheit_str);
    }

    fn convertToCelsius(self: *Self, fahrenheit_str: [:0]const u8) !void {
        std.log.debug("refreshing from fahrenheit {s}", .{fahrenheit_str});

        const fahrenheit_value = std.fmt.parseFloat(f32, fahrenheit_str) catch {
            self.celsius_text.setValue("");
            return;
        };

        const celsius_value = (fahrenheit_value - 32.0) * (5.0 / 9.0);
        var celsius_str = try std.fmt.allocPrintZ(self.allocator, "{d:.2}", .{celsius_value});
        defer self.allocator.free(celsius_str);

        self.celsius_text.setValue(celsius_str);
    }

    fn onFahrenheitChanged(text: *iup.Text, index: i32, value: [:0]const u8) !void {
        _ = index;
        var dialog = text.getDialog() orelse unreachable;
        var self = dialog.getPtrAttribute(Self, "parent") orelse @panic("Parent struct not set!");
        try self.convertToCelsius(value);
    }

    fn onCelsiusChanged(text: *iup.Text, index: i32, value: [:0]const u8) !void {
        _ = index;
        var dialog = text.getDialog() orelse unreachable;
        var self = dialog.getPtrAttribute(Self, "parent") orelse @panic("Parent struct not set!");
        try self.convertToFahrenheit(value);
    }
};
