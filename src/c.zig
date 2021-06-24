const std = @import("std");
const iup = @import("iup.zig");

usingnamespace @cImport({
    @cInclude("iup.h");
    @cInclude("iup_str.h");
});

// Helper functions to convert pointers between zig and C

pub inline fn getHandle(handle: anytype) *Ihandle {
    return @ptrCast(*Ihandle, handle);
}

pub inline fn fromHandle(comptime T: type, handle: *Ihandle) *T {
    return @ptrCast(*T, handle);
}

pub inline fn fromMemory(comptime T: type, ptr: [*c]u8) *T {
    return @ptrCast(*T, @alignCast(@alignOf(T), ptr));
}

pub inline fn toMemory(value: anytype) [*c]u8 {
    return @ptrCast([*c]u8, value);
}

pub inline fn toCStr(value: ?[:0]const u8) [*c]const u8 {
    if (value) |ptr| {
        return @ptrCast([*c]const u8, ptr);
    } else {
        return null;
    }
}

pub inline fn fromCStr(value: [*c]const u8) [:0]const u8 {
    return std.mem.sliceTo(value, 0);
}

pub inline fn getStrAttribute(handle: anytype, attribute: [:0]const u8, id1: anytype, id2: anytype) [:0]const u8 {
    var ret = blk: {
        if (@TypeOf(id1) != i32 and @TypeOf(id2) != i32) {
            break :blk IupGetAttribute(getHandle(handle), toCStr(attribute));
        } else if (@TypeOf(id2) != i32) {
            break :blk IupGetAttributeId(getHandle(handle), toCStr(attribute), id1);
        } else {
            break :blk IupGetAttributeId2(getHandle(handle), toCStr(attribute), id1, id2);
        }
    };

    if (ret == null) return "";
    return fromCStr(ret);
}

pub inline fn setStrAttribute(handle: anytype, attribute: [:0]const u8, id1: anytype, id2: anytype, value: [:0]const u8) void {
    if (@TypeOf(id1) != i32 and @TypeOf(id2) != i32) {
        IupSetStrAttribute(getHandle(handle), toCStr(attribute), toCStr(value));
    } else if (@TypeOf(id2) != i32) {
        IupSetStrAttributeId(getHandle(handle), toCStr(attribute), id1, toCStr(value));
    } else {
        IupSetStrAttributeId2(getHandle(handle), toCStr(attribute), id1, id2, toCStr(value));
    }
}

pub inline fn clearAttribute(handle: anytype, attribute: [:0]const u8, id1: anytype, id2: anytype) void {
    if (@TypeOf(id1) != i32 and @TypeOf(id2) != i32) {
        IupSetAttribute(getHandle(handle), toCStr(attribute), null);
    } else if (@TypeOf(id2) != i32) {
        IupSetAttributeId(getHandle(handle), toCStr(attribute), id1, null);
    } else {
        IupSetAttributeId2(getHandle(handle), toCStr(attribute), id1, id2, null);
    }
}

pub inline fn getBoolAttribute(handle: anytype, attribute: [:0]const u8, id1: anytype, id2: anytype) bool {
    var ret = blk: {
        if (@TypeOf(id1) != i32 and @TypeOf(id2) != i32) {
            break :blk IupGetInt(getHandle(handle), toCStr(attribute));
        } else if (@TypeOf(id2) != i32) {
            break :blk IupGetIntId(getHandle(handle), toCStr(attribute), id1);
        } else {
            break :blk IupGetIntId2(getHandle(handle), toCStr(attribute), id1, id2);
        }
    };

    return ret == 1;
}

pub inline fn setBoolAttribute(handle: anytype, attribute: [:0]const u8, id1: anytype, id2: anytype, value: bool) void {
    const str = if (value) "YES" else "NO";

    if (@TypeOf(id1) != i32 and @TypeOf(id2) != i32) {
        IupSetStrAttribute(getHandle(handle), toCStr(attribute), str);
    } else if (@TypeOf(id2) != i32) {
        IupSetStrAttributeId(getHandle(handle), toCStr(attribute), id1, str);
    } else {
        IupSetStrAttributeId2(getHandle(handle), toCStr(attribute), id2, str);
    }
}

pub inline fn getIntAttribute(handle: anytype, attribute: [:0]const u8, id1: anytype, id2: anytype) i32 {
    if (@TypeOf(id1) != i32 and @TypeOf(id2) != i32) {
        return IupGetInt(getHandle(handle), toCStr(attribute));
    } else if (@TypeOf(id2) != i32) {
        return IupGetIntId(getHandle(handle), toCStr(attribute), id1);
    } else {
        return IupGetIntId2(getHandle(handle), toCStr(attribute), id1, id2);
    }
}

pub inline fn setIntAttribute(handle: anytype, attribute: [:0]const u8, id1: anytype, id2: anytype, value: i32) void {
    if (@TypeOf(id1) != i32 and @TypeOf(id2) != i32) {
        IupSetInt(getHandle(handle), toCStr(attribute), value);
    } else if (@TypeOf(id2) != i32) {
        IupSetIntId(getHandle(handle), toCStr(attribute), id1, value);
    } else {
        IupSetIntId2(getHandle(handle), toCStr(attribute), id1, id2, value);
    }
}

pub inline fn getFloatAttribute(handle: anytype, attribute: [:0]const u8, id1: anytype, id2: anytype) f32 {
    if (@TypeOf(id1) != i32 and @TypeOf(id2) != i32) {
        return IupGetFloat(getHandle(handle), toCStr(attribute));
    } else if (@TypeOf(id2) != i32) {
        return IupGetFloatId(getHandle(handle), toCStr(attribute), Id1);
    } else {
        return IupGetFloatId2(getHandle(handle), toCStr(attribute), id1, id2);
    }
}

pub inline fn setFloatAttribute(handle: anytype, attribute: [:0]const u8, id1: anytype, id2: anytype, value: f32) void {
    if (@TypeOf(id1) != i32 and @TypeOf(id2) != i32) {
        IupSetFloat(getHandle(handle), toCStr(attribute), value);
    } else if (@TypeOf(id2) != i32) {
        IupSetFloatId(getHandle(handle), toCStr(attribute), id1, value);
    } else {
        IupSetFloatId2(getHandle(handle), toCStr(attribute), id1, id2, value);
    }
}

pub inline fn getDoubleAttribute(handle: anytype, attribute: [:0]const u8, id1: anytype, id2: anytype) f64 {
    if (@TypeOf(id1) != i32 and @TypeOf(id2) != i32) {
        return IupGetDouble(getHandle(handle), toCStr(attribute));
    } else if (@TypeOf(id2) != i32) {
        return IupGetDouble(getHandle(handle), toCStr(attribute), id1);
    } else {
        return IupGetDoubleId2(getHandle(handle), toCStr(attribute), id1, id2);
    }
}

pub inline fn setDoubleAttribute(handle: anytype, attribute: [:0]const u8, id1: anytype, id2: anytype, value: f64) void {
    if (@TypeOf(id1) != i32 and @TypeOf(id2) != i32) {
        IupSetDouble(getHandle(handle), toCStr(attribute), value);
    } else if (@TypeOf(id2) != i32) {
        IupSetDoubleId(getHandle(handle), toCStr(attribute), id1, value);
    } else {
        IupSetDoubleId2(getHandle(handle), toCStr(attribute), id1, id2, value);
    }
}

pub inline fn getHandleAttribute(handle: anytype, attribute: [:0]const u8, id1: anytype, id2: anytype) ?*Ihandle {
    if (@TypeOf(id1) != i32 and @TypeOf(id2) != i32) {
        return IupGetAttributeHandle(getHandle(handle), toCStr(attribute));
    } else if (@TypeOf(id2) != i32) {
        return IupGetAttributeHandleId(getHandle(handle), toCStr(attribute), id1);
    } else {
        return IupGetAttributeHandleId2(getHandle(handle), toCStr(attribute), id1, id2);
    }
}

pub inline fn setHandleAttribute(handle: anytype, attribute: [:0]const u8, id1: anytype, id2: anytype, value: anytype) void {
    if (@TypeOf(id1) != i32 and @TypeOf(id2) != i32) {
        IupSetAttributeHandle(getHandle(handle), toCStr(attribute), getHandle(value));
    } else if (@TypeOf(id2) != i32) {
        IupSetAttributeHandleId(getHandle(handle), toCStr(attribute), id1, getHandle(value));
    } else {
        IupSetAttributeHandleId2(getHandle(handle), toCStr(attribute), id1, id2, getHandle(value));
    }
}

pub inline fn getPtrAttribute(comptime T: type, handle: anytype, attribute: [:0]const u8, id1: anytype, id2: anytype) ?*T {
    var ret = blk: {
        if (@TypeOf(id1) != i32 and @TypeOf(id2) != i32) {
            break :blk IupGetAttribute(getHandle(handle), toCStr(attribute));
        } else if (@TypeOf(id2) != i32) {
            break :blk IupGetAttributeId(getHandle(handle), toCStr(attribute), id1);
        } else {
            break :blk IupGetAttributeId2(getHandle(handle), toCStr(attribute), id1, id2);
        }
    };
    if (ret == null) return null;

    return @ptrCast(*T, ret);
}

pub inline fn setPtrAttribute(comptime T: type, handle: anytype, attribute: [:0]const u8, id1: anytype, id2: anytype, value: ?*T) void {
    if (value) |ptr| {
        if (@TypeOf(id1) != i32 and @TypeOf(id2) != i32) {
            IupSetAttribute(getHandle(handle), toCStr(attribute), @ptrCast([*c]const u8, ptr));
        } else if (@TypeOf(id2) != i32) {
            IupSetAttributeId(getHandle(handle), toCStr(attribute), id1, @ptrCast([*c]const u8, ptr));
        } else {
            IupSetAttributeId2(getHandle(handle), toCStr(attribute), id1, id2, @ptrCast([*c]const u8, ptr));
        }
    } else {
        clearAttribute(handle, attribute, id1, id2);
    }
}

pub inline fn intIntToString(buffer: []u8, x: i32, y: i32, comptime separator: u8) [:0]const u8 {
    var fbs = std.io.fixedBufferStream(buffer);
    std.fmt.format(fbs.writer(), "{}{c}{}\x00", .{ x, separator, y }) catch unreachable;
    return buffer[0 .. fbs.pos - 1 :0];
}

pub fn getRgb(handle: anytype, attribute: [:0]const u8, id1: anytype, id2: anytype) iup.Rgb {
    var r: u8 = 0;
    var g: u8 = 0;
    var b: u8 = 0;
    var a: u8 = 0;

    if (@TypeOf(id1) != i32 and @TypeOf(id2) != i32) {
        IupGetRGBA(getHandle(handle), toCStr(attribute), &r, &g, &b, &a);
    } else if (@TypeOf(id2) != i32) {
        IupGetRGBId(getHandle(handle), toCStr(attribute), id1, &r, &g, &b);
        a = 255;
    } else {
        IupGetRGBId2(getHandle(handle), toCStr(attribute), id1, id2, &r, &g, &b);
        a = 255;
    }

    return .{
        .r = r,
        .g = g,
        .b = b,
        .a = if (a == 255) null else a,
    };
}

pub inline fn setRgb(handle: anytype, attribute: [:0]const u8, id1: anytype, id2: anytype, arg: iup.Rgb) void {
    
    if (@TypeOf(id1) != i32 and @TypeOf(id2) != i32) {
        if (arg.a == null) {
            IupSetRGB(getHandle(handle), toCStr(attribute), arg.r, arg.g, arg.b);
        } else {
            IupSetRGBA(getHandle(handle), toCStr(attribute), arg.r, arg.g, arg.b, arg.a.?);
        }
    } else if (@TypeOf(id2) != i32) {
        IupSetRGBId(getHandle(handle), toCStr(attribute), id1, arg.r, arg.g, arg.b);
    } else {
        IupSetRGBId2(getHandle(handle), toCStr(attribute), id1, id2, arg.r, arg.g, arg.b);
    }
}
