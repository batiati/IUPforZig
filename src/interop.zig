///
/// Wraps everyhing used from C API
/// No IUP's API is used directly from other place.
const std = @import("std");
const iup = @import("iup.zig");

const c = @cImport({
    @cInclude("iup.h");
    @cInclude("iupcontrols.h");
    @cInclude("iupdraw.h");
});

const trait = std.meta.trait;

pub const Handle = c.Ihandle;
pub const NativeCallbackFn = c.Icallback;

pub const consts = struct {
    pub const IUP_ERROR = c.IUP_ERROR;
    pub const IUP_NOERROR = c.IUP_NOERROR;
    pub const IUP_OPENED = c.IUP_OPENED;
    pub const IUP_INVALID = c.IUP_INVALID;
    pub const IUP_INVALID_ID = c.IUP_INVALID_ID;
    pub const IUP_IGNORE = c.IUP_IGNORE;
    pub const IUP_DEFAULT = c.IUP_DEFAULT;
    pub const IUP_CLOSE = c.IUP_CLOSE;
    pub const IUP_CONTINUE = c.IUP_CONTINUE;
    pub const IUP_CENTER = c.IUP_CENTER;
    pub const IUP_LEFT = c.IUP_LEFT;
    pub const IUP_RIGHT = c.IUP_RIGHT;
    pub const IUP_MOUSEPOS = c.IUP_MOUSEPOS;
    pub const IUP_CURRENT = c.IUP_CURRENT;
    pub const IUP_CENTERPARENT = c.IUP_CENTERPARENT;
    pub const IUP_LEFTPARENT = c.IUP_LEFTPARENT;
    pub const IUP_RIGHTPARENT = c.IUP_RIGHTPARENT;
    pub const IUP_TOP = c.IUP_TOP;
    pub const IUP_BOTTOM = c.IUP_BOTTOM;
    pub const IUP_TOPPARENT = c.IUP_TOPPARENT;
    pub const IUP_BOTTOMPARENT = c.IUP_BOTTOMPARENT;
    pub const IUP_BUTTON1 = c.IUP_BUTTON1;
    pub const IUP_BUTTON2 = c.IUP_BUTTON2;
    pub const IUP_BUTTON3 = c.IUP_BUTTON3;
    pub const IUP_BUTTON4 = c.IUP_BUTTON4;
    pub const IUP_BUTTON5 = c.IUP_BUTTON5;
};

pub inline fn getHandle(handle: anytype) *Handle {
    const HandleType = @TypeOf(handle);
    const typeInfo = @typeInfo(HandleType);

    if (HandleType == iup.Element) {
        return handle.getHandle();
    } else if (typeInfo == .Pointer and @typeInfo(typeInfo.Pointer.child) == .Opaque) {
        return @ptrCast(*Handle, handle);
    } else {
        @compileError("Invalid handle type " ++ @typeName(@TypeOf(handle)));
    }
}

pub inline fn fromHandle(comptime T: type, handle: *Handle) *T {
    return @ptrCast(*T, handle);
}

pub inline fn fromHandleName(comptime T: type, handle_name: [:0]const u8) ?*T {
    var handle = c.IupGetHandle(toCStr(handle_name));
    if (handle == null) return null;
    return fromHandle(T, handle.?);
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
    return @ptrCast(*T, c.IupCreate(T.CLASS_NAME));
}

pub inline fn create_image(comptime T: type, width: i32, height: i32, imgdata: ?[]const u8) ?*T {

    // From original C code: (*void)-1
    const SENTINEL = std.math.maxInt(usize);

    var params = [_]usize{ @intCast(usize, width), @intCast(usize, height), if (imgdata) |valid| @ptrToInt(valid.ptr) else SENTINEL, SENTINEL };

    return @ptrCast(*T, c.IupCreatev(T.CLASS_NAME, @ptrCast([*c]?*anyopaque, &params)));
}

pub inline fn destroy(element: anytype) void {
    c.IupDestroy(getHandle(element));
}

pub inline fn open() iup.Error!void {
    if (c.IupOpen(null, null) == c.IUP_ERROR) return iup.Error.OpenFailed;
    if (c.IupControlsOpen() == c.IUP_ERROR) return iup.Error.OpenFailed;

    c.IupImageLibOpen();
}

pub inline fn beginLoop() void {
    // Discards the result,
    // Zig error is stored in MainLoop struct
    _ = c.IupMainLoop();
}

pub inline fn exitLoop() void {
    c.IupExitLoop();
}

pub inline fn close() void {
    c.IupClose();
}

pub inline fn showVersion() void {
    c.IupVersionShow();
}

pub inline fn setHandle(handle: anytype, name: [:0]const u8) void {
    _ = c.IupSetHandle(toCStr(name), getHandle(handle));
}

pub inline fn getStrAttribute(handle: anytype, attribute: [:0]const u8, ids_tuple: anytype) [:0]const u8 {
    return getNullableStrAttribute(handle, attribute, ids_tuple) orelse "";
}

pub inline fn getNullableStrAttribute(handle: anytype, attribute: [:0]const u8, ids_tuple: anytype) ?[:0]const u8 {
    validateIds(ids_tuple);

    var ret = blk: {
        if (ids_tuple.len == 0) {
            break :blk c.IupGetAttribute(getHandle(handle), getAttribute(attribute));
        } else if (ids_tuple.len == 1) {
            break :blk c.IupGetAttributeId(getHandle(handle), getAttribute(attribute), ids_tuple.@"0");
        } else {
            break :blk c.IupGetAttributeId2(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", ids_tuple.@"1");
        }
    };

    if (ret == null) return null;
    return fromCStr(ret);
}

pub inline fn setStrAttribute(handle: anytype, attribute: [:0]const u8, ids_tuple: anytype, value: ?[:0]const u8) void {
    validateIds(ids_tuple);

    if (ids_tuple.len == 0) {
        c.IupSetStrAttribute(getHandle(handle), getAttribute(attribute), toCStr(value));
    } else if (ids_tuple.len == 1) {
        c.IupSetStrAttributeId(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", toCStr(value));
    } else {
        c.IupSetStrAttributeId2(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", ids_tuple.@"1", toCStr(value));
    }
}

pub inline fn clearAttribute(handle: anytype, attribute: [:0]const u8, ids_tuple: anytype) void {
    validateIds(ids_tuple);

    // Global callbacks have null handler
    const handlePtr: ?*Handle = if (@TypeOf(handle) == void) null else getHandle(handle);

    if (ids_tuple.len == 0) {
        c.IupSetAttribute(handlePtr, getAttribute(attribute), null);
    } else if (ids_tuple.len == 1) {
        c.IupSetAttributeId(handlePtr, getAttribute(attribute), ids_tuple.@"0", null);
    } else {
        c.IupSetAttributeId2(handlePtr, getAttribute(attribute), ids_tuple.@"0", ids_tuple.@"1", null);
    }
}

pub inline fn getBoolAttribute(handle: anytype, attribute: [:0]const u8, ids_tuple: anytype) bool {
    validateIds(ids_tuple);

    var ret = blk: {
        if (ids_tuple.len == 0) {
            break :blk c.IupGetInt(getHandle(handle), getAttribute(attribute));
        } else if (ids_tuple.len == 1) {
            break :blk c.IupGetIntId(getHandle(handle), getAttribute(attribute), ids_tuple.@"0");
        } else {
            break :blk c.IupGetIntId2(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", ids_tuple.@"1");
        }
    };

    return ret == 1;
}

pub inline fn setBoolAttribute(handle: anytype, attribute: [:0]const u8, ids_tuple: anytype, value: bool) void {
    validateIds(ids_tuple);

    const str = if (value) "YES" else "NO";

    if (ids_tuple.len == 0) {
        c.IupSetStrAttribute(getHandle(handle), getAttribute(attribute), str);
    } else if (ids_tuple.len == 1) {
        c.IupSetStrAttributeId(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", str);
    } else {
        c.IupSetStrAttributeId2(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", ids_tuple.@"1", str);
    }
}

pub inline fn getIntAttribute(handle: anytype, attribute: [:0]const u8, ids_tuple: anytype) i32 {
    validateIds(ids_tuple);

    if (ids_tuple.len == 0) {
        return c.IupGetInt(getHandle(handle), getAttribute(attribute));
    } else if (ids_tuple.len == 1) {
        return c.IupGetIntId(getHandle(handle), getAttribute(attribute), ids_tuple.@"0");
    } else {
        return c.IupGetIntId2(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", ids_tuple.@"1");
    }
}

pub inline fn setIntAttribute(handle: anytype, attribute: [:0]const u8, ids_tuple: anytype, value: i32) void {
    validateIds(ids_tuple);

    if (ids_tuple.len == 0) {
        c.IupSetInt(getHandle(handle), getAttribute(attribute), value);
    } else if (ids_tuple.len == 1) {
        c.IupSetIntId(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", value);
    } else {
        c.IupSetIntId2(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", ids_tuple.@"1", value);
    }
}

pub inline fn getFloatAttribute(handle: anytype, attribute: [:0]const u8, ids_tuple: anytype) f32 {
    validateIds(ids_tuple);

    if (ids_tuple.len == 0) {
        return c.IupGetFloat(getHandle(handle), getAttribute(attribute));
    } else if (ids_tuple.len == 1) {
        return c.IupGetFloatId(getHandle(handle), getAttribute(attribute), ids_tuple.@"0");
    } else {
        return c.IupGetFloatId2(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", ids_tuple.@"1");
    }
}

pub inline fn setFloatAttribute(handle: anytype, attribute: [:0]const u8, ids_tuple: anytype, value: f32) void {
    validateIds(ids_tuple);

    if (ids_tuple.len == 0) {
        c.IupSetFloat(getHandle(handle), getAttribute(attribute), value);
    } else if (ids_tuple.len == 1) {
        c.IupSetFloatId(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", value);
    } else {
        c.IupSetFloatId2(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", ids_tuple.@"1", value);
    }
}

pub inline fn getDoubleAttribute(handle: anytype, attribute: [:0]const u8, ids_tuple: anytype) f64 {
    validateIds(ids_tuple);

    if (ids_tuple.len == 0) {
        return c.IupGetDouble(getHandle(handle), getAttribute(attribute));
    } else if (ids_tuple.len == 1) {
        return c.IupGetDouble(getHandle(handle), getAttribute(attribute), ids_tuple.@"0");
    } else {
        return c.IupGetDoubleId2(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", ids_tuple.@"1");
    }
}

pub inline fn setDoubleAttribute(handle: anytype, attribute: [:0]const u8, ids_tuple: anytype, value: f64) void {
    validateIds(ids_tuple);

    if (ids_tuple.len == 0) {
        c.IupSetDouble(getHandle(handle), getAttribute(attribute), value);
    } else if (ids_tuple.len == 1) {
        c.IupSetDoubleId(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", value);
    } else {
        c.IupSetDoubleId2(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", ids_tuple.@"1", value);
    }
}

pub inline fn getHandleAttribute(handle: anytype, attribute: [:0]const u8, ids_tuple: anytype) ?*Handle {
    validateIds(ids_tuple);

    if (ids_tuple.len == 0) {
        return c.IupGetAttributeHandle(getHandle(handle), getAttribute(attribute));
    } else if (ids_tuple.len == 1) {
        return c.IupGetAttributeHandleId(getHandle(handle), getAttribute(attribute), ids_tuple.@"0");
    } else {
        return c.IupGetAttributeHandleId2(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", ids_tuple.@"1");
    }
}

pub inline fn setHandleAttribute(handle: anytype, attribute: [:0]const u8, ids_tuple: anytype, value: anytype) void {
    if (ids_tuple.len == 0) {
        c.IupSetAttributeHandle(getHandle(handle), getAttribute(attribute), getHandle(value));
    } else if (ids_tuple.len == 1) {
        c.IupSetAttributeHandleId(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", getHandle(value));
    } else {
        c.IupSetAttributeHandleId2(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", ids_tuple.@"1", getHandle(value));
    }
}

pub inline fn getPtrAttribute(comptime T: type, handle: anytype, attribute: [:0]const u8, ids_tuple: anytype) ?*T {
    validateIds(ids_tuple);

    var ret = blk: {
        if (ids_tuple.len == 0) {
            break :blk c.IupGetAttribute(getHandle(handle), getAttribute(attribute));
        } else if (ids_tuple.len == 1) {
            break :blk c.IupGetAttributeId(getHandle(handle), getAttribute(attribute), ids_tuple.@"0");
        } else {
            break :blk c.IupGetAttributeId2(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", ids_tuple.@"1");
        }
    };
    if (ret == null) return null;

    return @ptrCast(*T, @alignCast(@alignOf(*T), ret));
}

pub inline fn setPtrAttribute(comptime T: type, handle: anytype, attribute: [:0]const u8, ids_tuple: anytype, value: ?*T) void {
    validateIds(ids_tuple);

    if (value) |ptr| {
        if (ids_tuple.len == 0) {
            c.IupSetAttribute(getHandle(handle), getAttribute(attribute), @ptrCast([*c]const u8, ptr));
        } else if (ids_tuple.len == 1) {
            c.IupSetAttributeId(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", @ptrCast([*c]const u8, ptr));
        } else {
            c.IupSetAttributeId2(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", ids_tuple.@"1", @ptrCast([*c]const u8, ptr));
        }
    } else {
        clearAttribute(handle, attribute, ids_tuple);
    }
}

pub inline fn validateHandle(native_type: iup.NativeType, handle: anytype) !void {
    const ElementType = std.meta.Child(@TypeOf(handle));
    if (ElementType.NATIVE_TYPE != native_type) return iup.Error.InvalidElement;
}

pub fn getRgb(handle: anytype, attribute: [:0]const u8, ids_tuple: anytype) iup.Rgb {
    validateIds(ids_tuple);

    var r: u8 = 0;
    var g: u8 = 0;
    var b: u8 = 0;
    var a: u8 = 0;

    if (ids_tuple.len == 0) {
        c.IupGetRGBA(getHandle(handle), getAttribute(attribute), &r, &g, &b, &a);
    } else if (ids_tuple.len == 1) {
        c.IupGetRGBId(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", &r, &g, &b);
        a = 255;
    } else {
        c.IupGetRGBId2(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", ids_tuple.@"1", &r, &g, &b);
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

    if (arg.alias) |alias| {
        setStrAttribute(handle, attribute, ids_tuple, alias);
    } else {
        if (ids_tuple.len == 0) {
            if (arg.a == null) {
                c.IupSetRGB(getHandle(handle), getAttribute(attribute), arg.r, arg.g, arg.b);
            } else {
                c.IupSetRGBA(getHandle(handle), getAttribute(attribute), arg.r, arg.g, arg.b, arg.a.?);
            }
        } else if (ids_tuple.len == 1) {
            c.IupSetRGBId(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", arg.r, arg.g, arg.b);
        } else {
            c.IupSetRGBId2(getHandle(handle), getAttribute(attribute), ids_tuple.@"0", ids_tuple.@"1", arg.r, arg.g, arg.b);
        }
    }
}

pub inline fn setNativeCallback(handle: anytype, attribute: [:0]const u8, callback: NativeCallbackFn) void {
    if (@TypeOf(handle) == void) {
        // Global callback
        _ = c.IupSetFunction(attribute, callback);
    } else {
        _ = c.IupSetCallback(getHandle(handle), attribute, callback);
    }
}

pub inline fn setCallbackStoreAttribute(comptime TCallback: type, handle: anytype, attribute: [:0]const u8, value: ?*const TCallback) void {
    if (value) |ptr| {
        // Global callbacks have null handler
        const handlePtr: ?*Handle = if (@TypeOf(handle) == void) null else getHandle(handle);
        c.IupSetAttribute(handlePtr, toCStr(attribute), @ptrCast([*c]const u8, ptr));
    } else {
        clearAttribute(handle, attribute, .{});
    }
}

pub inline fn getCallbackStoreAttribute(comptime TCallback: type, handle: anytype, attribute: [:0]const u8) ?*const TCallback {

    // Global callbacks have null handler
    const handlePtr: ?*Handle = if (@TypeOf(handle) == void) null else getHandle(handle);

    var ret = c.IupGetAttribute(handlePtr, toCStr(attribute));
    if (ret == null) return null;
    return @ptrCast(*const TCallback, ret);
}

pub inline fn showXY(handle: anytype, x: iup.DialogPosX, y: iup.DialogPosY) iup.Error!void {
    const ret = c.IupShowXY(getHandle(handle), @enumToInt(x), @enumToInt(y));
    if (ret == c.IUP_ERROR) return iup.Error.InvalidAction;
}

pub inline fn show(handle: anytype) iup.Error!void {
    const ret = c.IupShow(getHandle(handle));
    if (ret == c.IUP_ERROR) return iup.Error.InvalidAction;
}

pub inline fn map(handle: anytype) iup.Error!void {
    const ret = c.IupMap(getHandle(handle));
    if (ret == c.IUP_ERROR) return iup.Error.InvalidAction;
}

pub inline fn popup(handle: anytype, x: iup.DialogPosX, y: iup.DialogPosY) iup.Error!void {
    const ret = c.IupPopup(getHandle(handle), @enumToInt(x), @enumToInt(y));
    if (ret == c.IUP_ERROR) return iup.Error.InvalidAction;
}

pub inline fn hide(handle: anytype) void {
    //Returns: IUP_NOERROR always.
    _ = c.IupHide(getHandle(handle));
}

pub inline fn postMessage(handle: anytype, s: [:0]const u8, i: i32, f: f64, p: ?*anyopaque) void {
    c.IupPostMessage(getHandle(handle), toCStr(s), i, f, p);
}

pub inline fn getDialog(handle: anytype) ?*iup.Dialog {
    if (c.IupGetDialog(getHandle(handle))) |value| {
        return fromHandle(iup.Dialog, value);
    } else {
        return null;
    }
}

pub inline fn getDialogChild(handle: anytype, byName: [:0]const u8) ?iup.Element {
    var child = c.IupGetDialogChild(getHandle(handle), toCStr(byName)) orelse return null;
    const className = c.IupGetClassName(child);
    return iup.Element.fromClassName(fromCStr(className), child);
}

pub inline fn append(parent: anytype, element: anytype) iup.Error!void {
    const ret = c.IupAppend(getHandle(parent), getHandle(element));
    if (ret == null) return iup.Error.InvalidChild;
}

pub inline fn refresh(handle: anytype) void {
    c.IupRefresh(getHandle(handle));
}

pub inline fn update(handle: anytype) void {
    c.IupUpdate(getHandle(handle));
}

pub inline fn updateChildren(handle: anytype) void {
    c.IupUpdateChildren(getHandle(handle));
}

pub inline fn redraw(handle: anytype, children: bool) void {
    c.IupRedraw(getHandle(handle), if (children) 1 else 0);
}

pub inline fn getChildCount(handle: anytype) i32 {
    return c.IupGetChildCount(getHandle(handle));
}

pub inline fn getChild(handle: anytype, index: i32) ?*Handle {
    return c.IupGetChild(getHandle(handle), index);
}

pub inline fn getClassName(handle: anytype) [:0]const u8 {
    return fromCStr(c.IupGetClassName(getHandle(handle)));
}

pub fn intIntToString(buffer: []u8, x: i32, y: i32, comptime separator: u8) [:0]const u8 {
    var fbs = std.io.fixedBufferStream(buffer);
    std.fmt.format(fbs.writer(), "{}{c}{}\x00", .{ x, separator, y }) catch unreachable;
    return buffer[0 .. fbs.pos - 1 :0];
}

pub fn strToIntInt(value: []const u8, separator: u8, a: *?i32, b: *?i32) void {
    const delimiter = [_]u8{separator};
    var iterator = std.mem.split(u8, value, delimiter[0..]);

    if (iterator.next()) |part| {
        if (std.fmt.parseInt(i32, part, 10)) |int| {
            a.* = int;
        } else |_| {}
    }

    if (iterator.next()) |part| {
        if (std.fmt.parseInt(i32, part, 10)) |int| {
            b.* = int;
        } else |_| {}
    }
}

pub fn convertLinColToPos(handle: anytype, lin: i32, col: i32) ?i32 {
    const UNINITALIZED = std.math.minInt(i32);
    var pos: i32 = UNINITALIZED;

    c.IupTextConvertLinColToPos(getHandle(handle), lin, col, &pos);

    if (pos == UNINITALIZED) {
        return null;
    } else {
        return pos;
    }
}

pub fn convertPosToLinCol(handle: anytype, pos: i32) ?iup.LinColPos {
    const UNDEFINED = std.math.minInt(i32);
    var lin: i32 = UNDEFINED;
    var col: i32 = UNDEFINED;

    c.IupTextConvertPosToLinCol(getHandle(handle), pos, &lin, &col);

    if (lin == UNDEFINED or col == UNDEFINED) {
        return null;
    } else {
        return iup.LinColPos{ .lin = lin, .col = col };
    }
}

pub inline fn drawBegin(handle: anytype) void {
    c.IupDrawBegin(getHandle(handle));
}

pub inline fn drawEnd(handle: anytype) void {
    c.IupDrawEnd(getHandle(handle));
}

pub inline fn drawSetClipRect(handle: anytype, x1: i32, y1: i32, x2: i32, y2: i32) void {
    c.IupDrawSetClipRect(getHandle(handle), x1, y1, x2, y2);
}

pub inline fn drawResetClip(handle: anytype) void {
    c.IupDrawResetClip(getHandle(handle));
}

pub inline fn drawGetClipRect(handle: anytype) iup.Rect {
    var rect: iup.Rect = undefined;
    c.IupDrawGetClipRect(getHandle(handle), &rect.x1, &rect.y1, &rect.x2, &rect.y2);
    return rect;
}

pub inline fn drawParentBackground(handle: anytype) void {
    c.IupDrawParentBackground(getHandle(handle));
}

pub inline fn drawLine(handle: anytype, x1: i32, y1: i32, x2: i32, y2: i32) void {
    c.IupDrawLine(getHandle(handle), x1, y1, x2, y2);
}

pub inline fn drawRectangle(handle: anytype, x1: i32, y1: i32, x2: i32, y2: i32) void {
    c.IupDrawRectangle(getHandle(handle), x1, y1, x2, y2);
}

pub inline fn drawArc(handle: anytype, x1: i32, y1: i32, x2: i32, y2: i32, a1: f64, a2: f64) void {
    c.IupDrawArc(getHandle(handle), x1, y1, x2, y2, a1, a2);
}

pub inline fn drawPolygon(handle: anytype, points: []const i32) void {
    c.IupDrawPolygon(getHandle(handle), points.ptr, @intCast(c_int, points.len));
}

pub inline fn drawText(handle: anytype, str: [:0]const u8, x: i32, y: i32, w: i32, h: i32) void {
    c.IupDrawText(getHandle(handle), toCStr(str), -1, x, y, w, h);
}

pub inline fn drawImage(handle: anytype, name: [:0]const u8, x: i32, y: i32, w: i32, h: i32) void {
    c.IupDrawImage(getHandle(handle), toCStr(name), x, y, w, h);
}

pub inline fn drawSelectRect(handle: anytype, x1: i32, y1: i32, x2: i32, y2: i32) void {
    c.IupDrawSelectRect(getHandle(handle), x1, y1, x2, y2);
}

pub inline fn drawFocusRect(handle: anytype, x1: i32, y1: i32, x2: i32, y2: i32) void {
    c.IupDrawFocusRect(getHandle(handle), x1, y1, x2, y2);
}

pub inline fn drawGetSize(handle: anytype) iup.DrawSize {
    var size: iup.DrawSize = undefined;
    c.IupDrawGetSize(getHandle(handle), &size.width, &size.height);
    return size;
}

pub inline fn drawGetTextSize(handle: anytype, str: [:0]const u8) iup.DrawSize {
    var size: iup.DrawSize = undefined;
    c.IupDrawGetTextSize(getHandle(handle), toCStr(str), &size.width, &size.height);
    return size;
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
