const std = @import("std");
const iup = @import("iup.zig");

const trait = std.meta.trait;

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

pub inline fn create(comptime T: type) ?*T {
    return @ptrCast(*T, IupCreate(T.CLASS_NAME));
}

pub inline fn create_image(comptime T: type, width: i32, height: i32, imgdata: ?[]const u8) ?*T {

    // From original C code: (*void)-1
    const SENTINEL = std.math.maxInt(usize);

    var params = [_]usize{ @intCast(usize, width), @intCast(usize, height), if (imgdata) |valid| @ptrToInt(valid.ptr) else SENTINEL, SENTINEL };

    return @ptrCast(*T, IupCreatev(T.CLASS_NAME, @ptrCast([*c]?*c_void, &params)));
}

pub inline fn destroy(element: anytype) void {
    IupDestroy(getHandle(element));
}

pub inline fn setHandle(handle: anytype, name: [:0]const u8) void {
    _ = IupSetHandle(toCStr(name), getHandle(handle));
}

pub inline fn getStrAttribute(handle: anytype, attribute: [:0]const u8, ids_tuple: anytype) [:0]const u8 {
    validateIds(ids_tuple);

    var ret = blk: {
        if (ids_tuple.len == 0) {
            break :blk IupGetAttribute(getHandle(handle), getAttribute(attribute));
        } else if (ids_tuple.len == 1) {
            break :blk IupGetAttributeId(getHandle(handle), getAttribute(attribute), ids_tuple.@"0");
        } else {
            break :blk IupGetAttributeId2(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", ids_tuple.@"1");
        }
    };

    if (ret == null) return "";
    return fromCStr(ret);
}

pub inline fn setStrAttribute(handle: anytype, attribute: [:0]const u8, ids_tuple: anytype, value: [:0]const u8) void {
    validateIds(ids_tuple);

    if (ids_tuple.len == 0) {
        IupSetAttribute(getHandle(handle), getAttribute(attribute), toCStr(value));
    } else if (ids_tuple.len == 1) {
        IupSetAttributeId(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", toCStr(value));
    } else {
        IupSetAttributeId2(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", ids_tuple.@"1", toCStr(value));
    }
}

pub inline fn clearAttribute(handle: anytype, attribute: [:0]const u8, ids_tuple: anytype) void {
    validateIds(ids_tuple);

    if (ids_tuple.len == 0) {
        IupSetAttribute(getHandle(handle), getAttribute(attribute), null);
    } else if (ids_tuple.len == 1) {
        IupSetAttributeId(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", null);
    } else {
        IupSetAttributeId2(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", ids_tuple.@"1", null);
    }
}

pub inline fn getBoolAttribute(handle: anytype, attribute: [:0]const u8, ids_tuple: anytype) bool {
    validateIds(ids_tuple);

    var ret = blk: {
        if (ids_tuple.len == 0) {
            break :blk IupGetInt(getHandle(handle), getAttribute(attribute));
        } else if (ids_tuple.len == 1) {
            break :blk IupGetIntId(getHandle(handle), getAttribute(attribute), ids_tuple.@"0");
        } else {
            break :blk IupGetIntId2(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", ids_tuple.@"1");
        }
    };

    return ret == 1;
}

pub inline fn setBoolAttribute(handle: anytype, attribute: [:0]const u8, ids_tuple: anytype, value: bool) void {
    validateIds(ids_tuple);

    const str = if (value) "YES" else "NO";

    if (ids_tuple.len == 0) {
        IupSetStrAttribute(getHandle(handle), getAttribute(attribute), str);
    } else if (ids_tuple.len == 1) {
        IupSetStrAttributeId(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", str);
    } else {
        IupSetStrAttributeId2(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", ids_tuple.@"1", str);
    }
}

pub inline fn getIntAttribute(handle: anytype, attribute: [:0]const u8, ids_tuple: anytype) i32 {
    validateIds(ids_tuple);

    if (ids_tuple.len == 0) {
        return IupGetInt(getHandle(handle), getAttribute(attribute));
    } else if (ids_tuple.len == 1) {
        return IupGetIntId(getHandle(handle), getAttribute(attribute), ids_tuple.@"0");
    } else {
        return IupGetIntId2(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", ids_tuple.@"1");
    }
}

pub inline fn setIntAttribute(handle: anytype, attribute: [:0]const u8, ids_tuple: anytype, value: i32) void {
    validateIds(ids_tuple);

    if (ids_tuple.len == 0) {
        IupSetInt(getHandle(handle), getAttribute(attribute), value);
    } else if (ids_tuple.len == 1) {
        IupSetIntId(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", value);
    } else {
        IupSetIntId2(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", ids_tuple.@"1", value);
    }
}

pub inline fn getFloatAttribute(handle: anytype, attribute: [:0]const u8, ids_tuple: anytype) f32 {
    validateIds(ids_tuple);

    if (ids_tuple.len == 0) {
        return IupGetFloat(getHandle(handle), getAttribute(attribute));
    } else if (ids_tuple.len == 1) {
        return IupGetFloatId(getHandle(handle), getAttribute(attribute), ids_tuple.@"0");
    } else {
        return IupGetFloatId2(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", ids_tuple.@"1");
    }
}

pub inline fn setFloatAttribute(handle: anytype, attribute: [:0]const u8, ids_tuple: anytype, value: f32) void {
    validateIds(ids_tuple);

    if (ids_tuple.len == 0) {
        IupSetFloat(getHandle(handle), getAttribute(attribute), value);
    } else if (ids_tuple.len == 1) {
        IupSetFloatId(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", value);
    } else {
        IupSetFloatId2(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", ids_tuple.@"1", value);
    }
}

pub inline fn getDoubleAttribute(handle: anytype, attribute: [:0]const u8, ids_tuple: anytype) f64 {
    validateIds(ids_tuple);

    if (ids_tuple.len == 0) {
        return IupGetDouble(getHandle(handle), getAttribute(attribute));
    } else if (ids_tuple.len == 1) {
        return IupGetDouble(getHandle(handle), getAttribute(attribute), ids_tuple.@"0");
    } else {
        return IupGetDoubleId2(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", ids_tuple.@"1");
    }
}

pub inline fn setDoubleAttribute(handle: anytype, attribute: [:0]const u8, ids_tuple: anytype, value: f64) void {
    validateIds(ids_tuple);

    if (ids_tuple.len == 0) {
        IupSetDouble(getHandle(handle), getAttribute(attribute), value);
    } else if (ids_tuple.len == 1) {
        IupSetDoubleId(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", value);
    } else {
        IupSetDoubleId2(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", ids_tuple.@"1", value);
    }
}

pub inline fn getHandleAttribute(handle: anytype, attribute: [:0]const u8, ids_tuple: anytype) ?*Ihandle {
    validateIds(ids_tuple);

    if (ids_tuple.len == 0) {
        return IupGetAttributeHandle(getHandle(handle), getAttribute(attribute));
    } else if (ids_tuple.len == 1) {
        return IupGetAttributeHandleId(getHandle(handle), getAttribute(attribute), ids_tuple.@"0");
    } else {
        return IupGetAttributeHandleId2(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", ids_tuple.@"1");
    }
}

pub inline fn setHandleAttribute(handle: anytype, attribute: [:0]const u8, ids_tuple: anytype, value: anytype) void {
    if (ids_tuple.len == 0) {
        IupSetAttributeHandle(getHandle(handle), getAttribute(attribute), getHandle(value));
    } else if (ids_tuple.len == 1) {
        IupSetAttributeHandleId(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", getHandle(value));
    } else {
        IupSetAttributeHandleId2(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", ids_tuple.@"1", getHandle(value));
    }
}

pub inline fn getPtrAttribute(comptime T: type, handle: anytype, attribute: [:0]const u8, ids_tuple: anytype) ?*T {
    validateIds(ids_tuple);

    var ret = blk: {
        if (ids_tuple.len == 0) {
            break :blk IupGetAttribute(getHandle(handle), getAttribute(attribute));
        } else if (ids_tuple.len == 1) {
            break :blk IupGetAttributeId(getHandle(handle), getAttribute(attribute), ids_tuple.@"0");
        } else {
            break :blk IupGetAttributeId2(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", ids_tuple.@"1");
        }
    };
    if (ret == null) return null;

    return @ptrCast(*T, ret);
}

pub inline fn setPtrAttribute(comptime T: type, handle: anytype, attribute: [:0]const u8, ids_tuple: anytype, value: ?*T) void {
    validateIds(ids_tuple);

    if (value) |ptr| {
        if (ids_tuple.len == 0) {
            IupSetAttribute(getHandle(handle), getAttribute(attribute), @ptrCast([*c]const u8, ptr));
        } else if (ids_tuple.len == 1) {
            IupSetAttributeId(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", @ptrCast([*c]const u8, ptr));
        } else {
            IupSetAttributeId2(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", ids_tuple.@"1", @ptrCast([*c]const u8, ptr));
        }
    } else {
        clearAttribute(handle, attribute, ids_tuple);
    }
}

pub fn getRgb(handle: anytype, attribute: [:0]const u8, ids_tuple: anytype) iup.Rgb {
    validateIds(ids_tuple);

    var r: u8 = 0;
    var g: u8 = 0;
    var b: u8 = 0;
    var a: u8 = 0;

    if (ids_tuple.len == 0) {
        IupGetRGBA(getHandle(handle), getAttribute(attribute), &r, &g, &b, &a);
    } else if (ids_tuple.len == 1) {
        IupGetRGBId(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", &r, &g, &b);
        a = 255;
    } else {
        IupGetRGBId2(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", ids_tuple.@"1", &r, &g, &b);
        a = 255;
    }

    return .{
        .r = r,
        .g = g,
        .b = b,
        .a = if (a == 255) null else a,
    };
}

pub inline fn setRgb(handle: anytype, attribute: [:0]const u8, ids_tuple: anytype, arg: iup.Rgb) void {
    validateIds(ids_tuple);

    if (ids_tuple.len == 0) {
        if (arg.a == null) {
            IupSetRGB(getHandle(handle), getAttribute(attribute), arg.r, arg.g, arg.b);
        } else {
            IupSetRGBA(getHandle(handle), getAttribute(attribute), arg.r, arg.g, arg.b, arg.a.?);
        }
    } else if (ids_tuple.len == 1) {
        IupSetRGBId(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", arg.r, arg.g, arg.b);
    } else {
        IupSetRGBId2(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", ids_tuple.@"1", arg.r, arg.g, arg.b);
    }
}

pub inline fn intIntToString(buffer: []u8, x: i32, y: i32, comptime separator: u8) [:0]const u8 {
    var fbs = std.io.fixedBufferStream(buffer);
    std.fmt.format(fbs.writer(), "{}{c}{}\x00", .{ x, separator, y }) catch unreachable;
    return buffer[0 .. fbs.pos - 1 :0];
}

fn validateIds(ids_tuple: anytype) void {
    if (comptime !trait.isTuple(@TypeOf(ids_tuple)) or ids_tuple.len > 2)
        @compileError("Expected a tuple with 0, 1 or 2 values");
}

inline fn getAttribute(value: [:0]const u8) [*c]const u8 {

    //pure numbers are used as attributes in IupList and IupMatrix
    //translate them into IDVALUE.
    const IDVALUE = "IDVALUE";
    const EMPTY = "";

    if (std.mem.eql(u8, value, IDVALUE)) {
        return @ptrCast([*c]const u8, EMPTY);
    } else {
        return toCStr(value);
    }
}
