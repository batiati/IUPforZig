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

pub inline fn getStrAttribute(handle: anytype, attribute: [:0]const u8) [:0]const u8 {
    var ret = IupGetAttribute(getHandle(handle), toCStr(attribute));
    if (ret == null) return "";

    return fromCStr(ret);
}

pub inline fn setStrAttribute(handle: anytype, attribute: [:0]const u8, value: [:0]const u8) void {
    IupSetStrAttribute(getHandle(handle), toCStr(attribute), toCStr(value));
}

pub inline fn clearAttribute(handle: anytype, attribute: [:0]const u8) void {
    IupSetAttribute(getHandle(handle), toCStr(attribute), null);
}

pub inline fn getBoolAttribute(handle: anytype, attribute: [:0]const u8) bool {
    return IupGetInt(getHandle(handle), toCStr(attribute)) == 1;
}

pub inline fn setBoolAttribute(handle: anytype, attribute: [:0]const u8, value: bool) void {
    IupSetStrAttribute(getHandle(handle), toCStr(attribute), if (value) "YES" else "NO");
}

pub inline fn getIntAttribute(handle: anytype, attribute: [:0]const u8) i32 {
    return IupGetInt(getHandle(handle), toCStr(attribute));
}

pub inline fn setIntAttribute(handle: anytype, attribute: [:0]const u8, value: i32) void {
    IupSetInt(getHandle(handle), toCStr(attribute), value);
}

pub inline fn getFloatAttribute(handle: anytype, attribute: [:0]const u8) f32 {
    return IupGetFloat(getHandle(handle), toCStr(attribute));
}

pub inline fn setFloatAttribute(handle: anytype, attribute: [:0]const u8, value: f32) void {
    IupSetFloat(getHandle(handle), toCStr(attribute), value);
}

pub inline fn getDoubleAttribute(handle: anytype, attribute: [:0]const u8) f64 {
    return IupGetDouble(getHandle(handle), toCStr(attribute));
}

pub inline fn setDoubleAttribute(handle: anytype, attribute: [:0]const u8, value: f64) void {
    IupSetDouble(getHandle(handle), toCStr(attribute), value);
}

pub inline fn getHandleAttribute(handle: anytype, attribute: [:0]const u8) ?*Ihandle {
    return IupGetAttributeHandle(getHandle(handle), toCStr(attribute));
}

pub inline fn setHandleAttribute(handle: anytype, attribute: [:0]const u8, value: anytype) void {
    IupSetAttributeHandle(getHandle(handle), toCStr(attribute), getHandle(value));
}

pub inline fn getPtrAttribute(comptime T: type, handle: anytype, attribute: [:0]const u8) ?*T {
    var ret = IupGetAttribute(getHandle(handle), toCStr(attribute));
    if (ret == null) return null;

    return @ptrCast(*T, ret);
}

pub inline fn setPtrAttribute(comptime T: type, handle: anytype, attribute: [:0]const u8, value: ?*T) void {
    if (value) |ptr| {
        IupSetAttribute(getHandle(handle), toCStr(attribute), @ptrCast([*c]const u8, ptr));
    } else {
        clearAttribute(handle, attribute);
    }
}

pub inline fn intIntToString(buffer: []u8, x: i32, y: i32, comptime separator: u8) [:0]const u8 {
    var fbs = std.io.fixedBufferStream(buffer);
    std.fmt.format(fbs.writer(), "{}{c}{}\x00", .{ x, separator, y }) catch unreachable;
    return buffer[0 .. fbs.pos - 1 :0];
}

pub fn getRgb(handle: anytype, attribute: [:0]const u8) iup.Rgb {
    var r: u8 = 0;
    var g: u8 = 0;
    var b: u8 = 0;
    var a: u8 = 0;
    IupGetRGBA(getHandle(handle), toCStr(attribute), &r, &g, &b, &a);

    return .{
        .r = r,
        .g = g,
        .b = b,
        .a = if (a == 255) null else a,
    };
}

pub inline fn setRgb(handle: anytype, attribute: [:0]const u8, arg: iup.Rgb) void {
    if (arg.a == null) {
        IupSetRGB(getHandle(handle), toCStr(attribute), arg.r, arg.g, arg.b);
    } else {
        IupSetRGBA(getHandle(handle), toCStr(attribute), arg.r, arg.g, arg.b, arg.a.?);
    }
}
