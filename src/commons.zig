const std = @import("std");
const interop = @import("interop.zig");

const ascii = std.ascii;
const testing = std.testing;

pub const NativeType = enum { Void, Control, Canvas, Dialog, Image, Menu, Other };

pub const Error = error{
    ///
    /// Open function must be called before any action
    NotInitialized,

    ///
    /// Only in UNIX can fail to open, because X-Windows may be not initialized.
    OpenFailed,

    ///
    /// Action cannot be executed (IUP_ERROR).
    InvalidAction,

    ///
    /// Wrong child usage
    InvalidChild,

    ///
    /// Wrong element usage
    InvalidElement,
};

pub const CallbackResult = error{
    /// 
    /// Returning this error inside a callback function means that this event must be ignored and not processed by the control and not propagated
    /// Used in keyboard event handlers for example
    Ignore,

    ///
    /// Returning this error inside a callback function means that this event will be propagated to the parent of the element receiving it.
    /// Used in keyboard event handlers for example
    Continue,

    ///
    /// Returning this error inside a callback function means that this event will end the application loop
    Close,
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
        var allocator = fba.allocator();

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

pub const DialogPosX = union(enum(i32)) {
    Left = interop.consts.IUP_LEFT,
    Center = interop.consts.IUP_CENTER,
    Right = interop.consts.IUP_RIGHT,
    MousePos = interop.consts.IUP_MOUSEPOS,
    Current = interop.consts.IUP_CURRENT,
    CenterParent = interop.consts.IUP_CENTERPARENT,
    LeftParent = interop.consts.IUP_LEFTPARENT,
    RightParent = interop.consts.IUP_RIGHTPARENT,
    X: i32,
};

pub const DialogPosY = union(enum(i32)) {
    Top = interop.consts.IUP_TOP,
    Center = interop.consts.IUP_CENTER,
    Bottom = interop.consts.IUP_BOTTOM,
    MousePos = interop.consts.IUP_MOUSEPOS,
    CenterParent = interop.consts.IUP_CENTERPARENT,
    Current = interop.consts.IUP_CURRENT,
    TopParent = interop.consts.IUP_TOPPARENT,
    BottomParent = interop.consts.IUP_BOTTOMPARENT,
    Y: i32,
};

pub const Margin = struct {
    horiz: i32,
    vert: i32,

    pub fn parse(value: [:0]const u8) Margin {
        const separator = 'x';
        var horiz: ?i32 = null;
        var vert: ?i32 = null;
        interop.strToIntInt(value, separator, &horiz, &vert);

        return .{ .horiz = horiz orelse 0, .vert = vert orelse 0 };
    }

    pub fn toString(self: Margin, buffer: []u8) [:0]const u8 {
        return interop.intIntToString(buffer, self.horiz, self.vert, 'x');
    }

    pub fn intIntToString(buffer: []u8, horiz: i32, vert: i32) [:0]const u8 {
        return interop.intIntToString(buffer, horiz, vert, 'x');
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
        var width: ?i32 = null;
        var height: ?i32 = null;
        interop.strToIntInt(value, separator, &width, &height);

        return .{ .width = width, .height = height };
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
        var x: ?i32 = null;
        var y: ?i32 = null;
        interop.strToIntInt(value, separator, &x, &y);

        return .{ .x = x orelse 0, .y = y orelse 0 };
    }

    pub fn toString(self: Self, buffer: []u8, comptime separator: u8) [:0]const u8 {
        return interop.intIntToString(buffer, self.x, self.y, separator);
    }

    pub fn intIntToString(buffer: []u8, x: i32, y: i32, comptime separator: u8) [:0]const u8 {
        return interop.intIntToString(buffer, x, y, separator);
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
        var lin: ?i32 = null;
        var col: ?i32 = null;
        interop.strToIntInt(value, separator, &lin, &col);

        return .{ .col = col orelse 0, .lin = lin orelse 0 };
    }

    pub fn toString(self: Self, buffer: []u8, comptime separator: u8) [:0]const u8 {
        return interop.intIntToString(buffer, self.lin, self.col, separator);
    }

    pub fn intIntToString(buffer: []u8, x: i32, y: i32, comptime separator: u8) [:0]const u8 {
        return interop.intIntToString(buffer, x, y, separator);
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
        var begin: ?i32 = null;
        var end: ?i32 = null;
        interop.strToIntInt(value, separator, &begin, &end);

        return .{ .begin = begin orelse 0, .end = end orelse 0 };
    }

    pub fn toString(self: Self, buffer: []u8, comptime separator: u8) [:0]const u8 {
        return interop.intIntToString(buffer, self.begin, self.end, separator);
    }

    pub fn intIntToString(buffer: []u8, begin: i32, end: i32, comptime separator: u8) [:0]const u8 {
        return interop.intIntToString(buffer, begin, end, separator);
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
    alias: ?[:0]const u8 = null,

    pub const BG_COLOR = Rgb{ .alias = "BGCOLOR", .r = 0, .g = 0, .b = 0 };
    pub const FG_COLOR = Rgb{ .alias = "FGCOLOR", .r = 0, .g = 0, .b = 0 };
};

pub const keys = struct {
    pub const PAUSE = 0xFF13;
    pub const ESC = 0xFF1B;
    pub const HOME = 0xFF50;
    pub const LEFT = 0xFF51;
    pub const UP = 0xFF52;
    pub const RIGHT = 0xFF53;
    pub const DOWN = 0xFF54;
    pub const PGUP = 0xFF55;
    pub const PGDN = 0xFF56;
    pub const END = 0xFF57;
    pub const MIDDLE = 0xFF0B;
    pub const Print = 0xFF61;
    pub const INS = 0xFF63;
    pub const Menu = 0xFF67;
    pub const DEL = 0xFFFF;
    pub const F1 = 0xFFBE;
    pub const F2 = 0xFFBF;
    pub const F3 = 0xFFC0;
    pub const F4 = 0xFFC1;
    pub const F5 = 0xFFC2;
    pub const F6 = 0xFFC3;
    pub const F7 = 0xFFC4;
    pub const F8 = 0xFFC5;
    pub const F9 = 0xFFC6;
    pub const F10 = 0xFFC7;
    pub const F11 = 0xFFC8;
    pub const F12 = 0xFFC9;
    pub const F13 = 0xFFCA;
    pub const F14 = 0xFFCB;
    pub const F15 = 0xFFCC;
    pub const F16 = 0xFFCD;
    pub const F17 = 0xFFCE;
    pub const F18 = 0xFFCF;
    pub const F19 = 0xFFD0;
    pub const F20 = 0xFFD1;
    pub const LSHIFT = 0xFFE1;
    pub const RSHIFT = 0xFFE2;
    pub const LCTRL = 0xFFE3;
    pub const RCTRL = 0xFFE4;
    pub const LALT = 0xFFE9;
    pub const RALT = 0xFFEA;
    pub const NUM = 0xFF7F;
    pub const SCROLL = 0xFF14;
    pub const CAPS = 0xFFE5;
    pub const CLEAR = 0xFFD2;
    pub const HELP = 0xFFD3;
};
