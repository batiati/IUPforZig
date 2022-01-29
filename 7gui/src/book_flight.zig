/// Flight Booker
/// Challenge: Constraints.
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

    var book_flight = try BookFlight.init(gpa.allocator(), 0);
    defer book_flight.deinit();

    try book_flight.show();
    try iup.MainLoop.beginLoop();
}

const BookFlight = struct {
    const Self = @This();

    const Flight = enum(u8) {
        OneWayFlight = 1,
        ReturnFlight = 2,
    };

    counter: usize,
    allocator: Allocator,
    dialog: *iup.Dialog = undefined,
    list: *iup.List = undefined,
    initial_date: *iup.DatePick = undefined,
    final_date: *iup.DatePick = undefined,
    book_button: *iup.Button = undefined,

    pub fn init(allocator: Allocator, counter: usize) !*Self {
        var self = try allocator.create(Self);

        self.* = .{
            .counter = counter,
            .allocator = allocator,
        };

        try self.createDialog();
        self.refreshEnabled();

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
            .setTitle("Flight Booker")
            .setSize(iup.ScreenSize{ .Size = 140 }, iup.ScreenSize{ .Size = 100 })
            .setChildren(
            .{
                iup.VBox.init()
                    .setExpandChildren(true)
                    .setMargin(10, 10)
                    .setGap(10)
                    .setChildren(
                    .{
                        iup.List.init()
                            .capture(&self.list)
                            .setActionCallback(onSelected)
                            .setDropDown(true)
                            .setValue("1")
                            .setItems(1, "one-way flight")
                            .setItems(2, "return flight"),
                        iup.DatePick.init()
                            .setValueChangedCallback(onValueChanged)
                            .capture(&self.initial_date),
                        iup.DatePick.init()
                            .setValueChangedCallback(onValueChanged)
                            .capture(&self.final_date),
                        iup.Button.init()
                            .capture(&self.book_button)
                            .setActionCallback(onClick)
                            .setTitle("Book"),
                    },
                ),
            },
        ).unwrap();
    }

    fn onSelected(list: *iup.List, text: [:0]const u8, x: i32, y: i32) !void {
        _ = text;
        _ = x;
        _ = y;

        var dialog = list.getDialog() orelse unreachable;
        var self = dialog.getPtrAttribute(Self, "parent") orelse @panic("Parent struct not set!");
        self.refreshEnabled();
    }

    fn onValueChanged(datepick: *iup.DatePick) !void {
        var dialog = datepick.getDialog() orelse unreachable;
        var self = dialog.getPtrAttribute(Self, "parent") orelse @panic("Parent struct not set!");
        self.refreshEnabled();
    }

    fn onClick(button: *iup.Button) !void {
        var dialog = button.getDialog() orelse unreachable;
        var self = dialog.getPtrAttribute(Self, "parent") orelse @panic("Parent struct not set!");

        try self.book();
    }

    fn refreshEnabled(self: *Self) void {
        self.final_date.setActive(self.getSelection() == .ReturnFlight);
        self.book_button.setActive(self.isValid());
    }

    fn getSelection(self: *Self) Flight {
        const index = std.fmt.parseInt(u8, self.list.getValue(), 10) catch return .OneWayFlight;
        return @intToEnum(Flight, index);
    }

    fn book(self: *Self) !void {
        if (self.isValid()) {
            var message = if (self.getSelection() == .OneWayFlight)
                try std.fmt.allocPrintZ(self.allocator, "You have booked a one-way flight for {s}", .{self.initial_date.getValue()})
            else
                try std.fmt.allocPrintZ(self.allocator, "You have booked a return flight from {s} to {s}", .{ self.initial_date.getValue(), self.final_date.getValue() });
            defer self.allocator.free(message);

            var dialog = try iup.MessageDlg.init()
                .setTitle(self.dialog.getTitle())
                .setParentDialog(self.dialog)
                .setValue(message)
                .setDialogType(.Information)
                .unwrap();
            defer dialog.deinit();

            _ = try dialog.popup(.CenterParent, .CenterParent);
        }
    }

    fn isValid(self: *Self) bool {
        if (self.getSelection() == .ReturnFlight) {
            std.log.debug("isValid from: {s} to: {s}", .{ self.initial_date.getValue(), self.final_date.getValue() });

            var initial_date = iup.Date.parse(self.initial_date.getValue()) orelse return false;
            var final_date = iup.Date.parse(self.final_date.getValue()) orelse return false;

            return (final_date.year > initial_date.year) or
                (final_date.year == initial_date.year and final_date.month > initial_date.month) or
                (final_date.year == initial_date.year and final_date.month == initial_date.month and final_date.day >= initial_date.day);
        } else {
            return true;
        }
    }
};
