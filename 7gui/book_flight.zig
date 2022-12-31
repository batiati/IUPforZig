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

    var book_flight = try BookFlight.init(gpa.allocator());
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

    allocator: Allocator,
    dialog: *iup.Dialog = undefined,
    list: *iup.List = undefined,
    initial_date: *iup.DatePick = undefined,
    final_date: *iup.DatePick = undefined,
    book_button: *iup.Button = undefined,

    pub fn init(allocator: Allocator) !*Self {
        var self = try allocator.create(Self);

        self.* = .{
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

            try iup.MessageDlg.alert(self.dialog, self.dialog.getTitle(), message);
        }
    }

    fn isValid(self: *Self) bool {
        if (self.getSelection() == .ReturnFlight) {
            return DateComparer.greaterOrEqualsThan(
                self.final_date.getValue(),
                self.initial_date.getValue(),
            );
        } else {
            return true;
        }
    }
};

const DateComparer = struct {
    pub fn greaterOrEqualsThan(date_str1: [:0]const u8, date_str2: [:0]const u8) bool {
        var date1 = iup.Date.parse(date_str1) orelse return false;
        var date2 = iup.Date.parse(date_str2) orelse return false;

        return (date1.year > date2.year) or
            (date1.year == date2.year and date1.month > date2.month) or
            (date1.year == date2.year and date1.month == date2.month and date1.day >= date2.day);
    }

    test "greater or equals than" {
        try std.testing.expectEqual(false, greaterOrEqualsThan("1900/01/01", "1900/01/02"));
        try std.testing.expectEqual(true, greaterOrEqualsThan("1900/01/03", "1900/01/02"));
        try std.testing.expectEqual(true, greaterOrEqualsThan("1900/02/01", "1900/01/02"));
        try std.testing.expectEqual(true, greaterOrEqualsThan("1901/01/01", "1900/01/02"));
    }
};
