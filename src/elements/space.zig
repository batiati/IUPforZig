// This code was generated by a tool.
// IUP Metadata Code Generator
// https://github.com/batiati/IUPMetadata
//
//
// Changes to this file may cause incorrect behavior and will be lost if
// the code is regenerated.

const std = @import("std");

const c = @import("../c.zig");
const iup = @import("../iup.zig");

const Impl = @import("../impl.zig").Impl;
const CallbackHandler = @import("../callback_handler.zig").CallbackHandler;

const debug = std.debug;
const trait = std.meta.trait;

const Element = iup.Element;
const Handle = iup.Handle;
const Error = iup.Error;
const ChildrenIterator = iup.ChildrenIterator;
const Size = iup.Size;
const Margin = iup.Margin;

/// 
/// Creates void element, which occupies an empty space.
/// It does not have a native representation.
pub const Space = opaque {
    pub const CLASS_NAME = "space";
    const Self = @This();

    pub const OnLDestroyFn = fn (self: *Self) anyerror!void;

    /// 
    /// DESTROY_CB DESTROY_CB Called right before an element is destroyed.
    /// Callback int function(Ihandle *ih); [in C] ih:destroy_cb() -> (ret: number)
    /// [in Lua] ih: identifier of the element that activated the event.
    /// Notes If the dialog is visible then it is hidden before it is destroyed.
    /// The callback will be called right after it is hidden.
    /// The callback will be called before all other destroy procedures.
    /// For instance, if the element has children then it is called before the
    /// children are destroyed.
    /// For language binding implementations use the callback name "LDESTROY_CB" to
    /// release memory allocated by the binding for the element.
    /// Also the callback will be called before the language callback.
    /// Affects All.
    pub const OnDestroyFn = fn (self: *Self) anyerror!void;

    /// 
    /// MAP_CB MAP_CB Called right after an element is mapped and its attributes
    /// updated in IupMap.
    /// When the element is a dialog, it is called after the layout is updated.
    /// For all other elements is called before the layout is updated, so the
    /// element current size will still be 0x0 during MAP_CB (since 3.14).
    /// Callback int function(Ihandle *ih); [in C] ih:map_cb() -> (ret: number) [in
    /// Lua] ih: identifier of the element that activated the event.
    /// Affects All that have a native representation.
    pub const OnMapFn = fn (self: *Self) anyerror!void;

    pub const OnPostMessageFn = fn (self: *Self, arg0: [:0]const u8, arg1: i32, arg2: f64, arg3: *iup.Unknow) anyerror!void;

    /// 
    /// UNMAP_CB UNMAP_CB Called right before an element is unmapped.
    /// Callback int function(Ihandle *ih); [in C] ih:unmap_cb() -> (ret: number)
    /// [in Lua] ih: identifier of the element that activated the event.
    /// Affects All that have a native representation.
    pub const OnUnmapFn = fn (self: *Self) anyerror!void;

    pub const Expand = enum {
        Yes,
        Horizontal,
        Vertical,
        HorizontalFree,
        VerticalFree,
        No,
    };

    pub const Floating = enum {
        Yes,
        Ignore,
        No,
    };

    pub const Initializer = struct {
        last_error: ?anyerror = null,
        ref: *Self,

        ///
        /// Returns a pointer to IUP element or an error.
        /// Only top-level or detached elements needs to be unwraped,
        pub fn unwrap(self: Initializer) !*Self {
            if (self.last_error) |e| {
                return e;
            } else {
                return self.ref;
            }
        }

        ///
        /// Captures a reference into a external variable
        /// Allows to capture some references even using full declarative API
        pub fn capture(self: *Initializer, ref: **Self) Initializer {
            ref.* = self.ref;
            return self.*;
        }

        pub fn setStrAttribute(self: *Initializer, attributeName: [:0]const u8, arg: [:0]const u8) Initializer {
            if (self.last_error) |_| return self.*;
            Self.setStrAttribute(self.ref, attributeName, arg);
            return self.*;
        }

        pub fn setIntAttribute(self: *Initializer, attributeName: [:0]const u8, arg: i32) Initializer {
            if (self.last_error) |_| return self.*;
            Self.setIntAttribute(self.ref, attributeName, arg);
            return self.*;
        }

        pub fn setBoolAttribute(self: *Initializer, attributeName: [:0]const u8, arg: bool) Initializer {
            if (self.last_error) |_| return self.*;
            Self.setBoolAttribute(self.ref, attributeName, bool);
            return self.*;
        }

        pub fn setPtrAttribute(self: *Initializer, comptime T: type, attributeName: [:0]const u8, value: ?*T) Initializer {
            if (self.last_error) |_| return self.*;
            Self.setPtrAttribute(self.ref, T, attributeName, value);
            return self.*;
        }

        pub fn setUserSize(self: *Initializer, width: ?i32, height: ?i32) Initializer {
            var buffer: [128]u8 = undefined;
            var value = Size.intIntToString(&buffer, width, height);
            c.setStrAttribute(self.ref, "USERSIZE", .{}, value);
            return self.*;
        }

        pub fn setFontStyle(self: *Initializer, arg: [:0]const u8) Initializer {
            c.setStrAttribute(self.ref, "FONTSTYLE", .{}, arg);
            return self.*;
        }

        pub fn setFontSize(self: *Initializer, arg: i32) Initializer {
            c.setIntAttribute(self.ref, "FONTSIZE", .{}, arg);
            return self.*;
        }

        pub fn setExpandWeight(self: *Initializer, arg: f64) Initializer {
            c.setDoubleAttribute(self.ref, "EXPANDWEIGHT", .{}, arg);
            return self.*;
        }

        pub fn setMaxSize(self: *Initializer, width: ?i32, height: ?i32) Initializer {
            var buffer: [128]u8 = undefined;
            var value = Size.intIntToString(&buffer, width, height);
            c.setStrAttribute(self.ref, "MAXSIZE", .{}, value);
            return self.*;
        }

        pub fn setActive(self: *Initializer, arg: bool) Initializer {
            c.setBoolAttribute(self.ref, "ACTIVE", .{}, arg);
            return self.*;
        }

        pub fn setNTheme(self: *Initializer, arg: [:0]const u8) Initializer {
            c.setStrAttribute(self.ref, "NTHEME", .{}, arg);
            return self.*;
        }

        pub fn setVisible(self: *Initializer, arg: bool) Initializer {
            c.setBoolAttribute(self.ref, "VISIBLE", .{}, arg);
            return self.*;
        }

        pub fn setFontFace(self: *Initializer, arg: [:0]const u8) Initializer {
            c.setStrAttribute(self.ref, "FONTFACE", .{}, arg);
            return self.*;
        }

        pub fn setPropagateFocus(self: *Initializer, arg: bool) Initializer {
            c.setBoolAttribute(self.ref, "PROPAGATEFOCUS", .{}, arg);
            return self.*;
        }

        pub fn setHandleName(self: *Initializer, arg: [:0]const u8) Initializer {
            c.setStrAttribute(self.ref, "HANDLENAME", .{}, arg);
            return self.*;
        }


        /// 
        /// SIZE, RASTERSIZE, EXPAND, FONT, POSITION, MINSIZE, MAXSIZE, THEME: also accepted.
        pub fn setSize(self: *Initializer, width: ?i32, height: ?i32) Initializer {
            var buffer: [128]u8 = undefined;
            var value = Size.intIntToString(&buffer, width, height);
            c.setStrAttribute(self.ref, "SIZE", .{}, value);
            return self.*;
        }

        pub fn setNormalizerGroup(self: *Initializer, arg: [:0]const u8) Initializer {
            c.setStrAttribute(self.ref, "NORMALIZERGROUP", .{}, arg);
            return self.*;
        }

        pub fn setFont(self: *Initializer, arg: [:0]const u8) Initializer {
            c.setStrAttribute(self.ref, "FONT", .{}, arg);
            return self.*;
        }

        pub fn setName(self: *Initializer, arg: [:0]const u8) Initializer {
            c.setStrAttribute(self.ref, "NAME", .{}, arg);
            return self.*;
        }

        pub fn setExpand(self: *Initializer, arg: ?Expand) Initializer {
            if (arg) |value| switch (value) {
                .Yes => c.setStrAttribute(self.ref, "EXPAND", .{}, "YES"),
                .Horizontal => c.setStrAttribute(self.ref, "EXPAND", .{}, "HORIZONTAL"),
                .Vertical => c.setStrAttribute(self.ref, "EXPAND", .{}, "VERTICAL"),
                .HorizontalFree => c.setStrAttribute(self.ref, "EXPAND", .{}, "HORIZONTALFREE"),
                .VerticalFree => c.setStrAttribute(self.ref, "EXPAND", .{}, "VERTICALFREE"),
                .No => c.setStrAttribute(self.ref, "EXPAND", .{}, "NO"),
            } else {
                c.clearAttribute(self.ref, "EXPAND", .{});
            }
            return self.*;
        }

        pub fn setCanFocus(self: *Initializer, arg: bool) Initializer {
            c.setBoolAttribute(self.ref, "CANFOCUS", .{}, arg);
            return self.*;
        }

        pub fn setRasterSize(self: *Initializer, width: ?i32, height: ?i32) Initializer {
            var buffer: [128]u8 = undefined;
            var value = Size.intIntToString(&buffer, width, height);
            c.setStrAttribute(self.ref, "RASTERSIZE", .{}, value);
            return self.*;
        }

        pub fn setFloating(self: *Initializer, arg: ?Floating) Initializer {
            if (arg) |value| switch (value) {
                .Yes => c.setStrAttribute(self.ref, "FLOATING", .{}, "YES"),
                .Ignore => c.setStrAttribute(self.ref, "FLOATING", .{}, "IGNORE"),
                .No => c.setStrAttribute(self.ref, "FLOATING", .{}, "NO"),
            } else {
                c.clearAttribute(self.ref, "FLOATING", .{});
            }
            return self.*;
        }

        pub fn setTheme(self: *Initializer, arg: [:0]const u8) Initializer {
            c.setStrAttribute(self.ref, "THEME", .{}, arg);
            return self.*;
        }

        pub fn setMinSize(self: *Initializer, width: ?i32, height: ?i32) Initializer {
            var buffer: [128]u8 = undefined;
            var value = Size.intIntToString(&buffer, width, height);
            c.setStrAttribute(self.ref, "MINSIZE", .{}, value);
            return self.*;
        }

        pub fn setPosition(self: *Initializer, x: i32, y: i32) Initializer {
            var buffer: [128]u8 = undefined;
            var value = iup.XYPos.intIntToString(&buffer, x, y, ',');
            c.setStrAttribute(self.ref, "POSITION", .{}, value);
            return self.*;
        }

        pub fn setLDestroyCallback(self: *Initializer, callback: ?OnLDestroyFn) Initializer {
            const Handler = CallbackHandler(Self, OnLDestroyFn, "LDESTROY_CB");
            Handler.setCallback(self.ref, callback);
            return self.*;
        }

        /// 
        /// DESTROY_CB DESTROY_CB Called right before an element is destroyed.
        /// Callback int function(Ihandle *ih); [in C] ih:destroy_cb() -> (ret: number)
        /// [in Lua] ih: identifier of the element that activated the event.
        /// Notes If the dialog is visible then it is hidden before it is destroyed.
        /// The callback will be called right after it is hidden.
        /// The callback will be called before all other destroy procedures.
        /// For instance, if the element has children then it is called before the
        /// children are destroyed.
        /// For language binding implementations use the callback name "LDESTROY_CB" to
        /// release memory allocated by the binding for the element.
        /// Also the callback will be called before the language callback.
        /// Affects All.
        pub fn setDestroyCallback(self: *Initializer, callback: ?OnDestroyFn) Initializer {
            const Handler = CallbackHandler(Self, OnDestroyFn, "DESTROY_CB");
            Handler.setCallback(self.ref, callback);
            return self.*;
        }

        /// 
        /// MAP_CB MAP_CB Called right after an element is mapped and its attributes
        /// updated in IupMap.
        /// When the element is a dialog, it is called after the layout is updated.
        /// For all other elements is called before the layout is updated, so the
        /// element current size will still be 0x0 during MAP_CB (since 3.14).
        /// Callback int function(Ihandle *ih); [in C] ih:map_cb() -> (ret: number) [in
        /// Lua] ih: identifier of the element that activated the event.
        /// Affects All that have a native representation.
        pub fn setMapCallback(self: *Initializer, callback: ?OnMapFn) Initializer {
            const Handler = CallbackHandler(Self, OnMapFn, "MAP_CB");
            Handler.setCallback(self.ref, callback);
            return self.*;
        }

        pub fn setPostMessageCallback(self: *Initializer, callback: ?OnPostMessageFn) Initializer {
            const Handler = CallbackHandler(Self, OnPostMessageFn, "POSTMESSAGE_CB");
            Handler.setCallback(self.ref, callback);
            return self.*;
        }

        /// 
        /// UNMAP_CB UNMAP_CB Called right before an element is unmapped.
        /// Callback int function(Ihandle *ih); [in C] ih:unmap_cb() -> (ret: number)
        /// [in Lua] ih: identifier of the element that activated the event.
        /// Affects All that have a native representation.
        pub fn setUnmapCallback(self: *Initializer, callback: ?OnUnmapFn) Initializer {
            const Handler = CallbackHandler(Self, OnUnmapFn, "UNMAP_CB");
            Handler.setCallback(self.ref, callback);
            return self.*;
        }
    };

    ///
    /// Creates an interface element given its class name and parameters.
    /// After creation the element still needs to be attached to a container and mapped to the native system so it can be visible.
    pub fn init() Initializer {
        var handle = c.IupCreate(Self.CLASS_NAME);

        if (handle) |valid| {
            return .{
                .ref = @ptrCast(*Self, valid),
            };
        } else {
            return .{ .ref = undefined, .last_error = Error.NotInitialized };
        }
    }

    /// 
    /// Destroys an interface element and all its children.
    /// Only dialogs, timers, popup menus and images should be normally destroyed, but detached elements can also be destroyed.        
    pub fn deinit(self: *Self) void {
        c.IupDestroy(c.getHandle(self));
    }

    pub fn setStrAttribute(self: *Self, attribute: [:0]const u8, arg: [:0]const u8) void {
        c.setStrAttribute(self, attribute, .{}, arg);
    }

    pub fn getStrAttribute(self: *Self, attribute: [:0]const u8) [:0]const u8 {
        return c.getStrAttribute(self, attribute, .{});
    }

    pub fn setIntAttribute(self: *Self, attribute: [:0]const u8, arg: i32) void {
        c.setIntAttribute(self, attribute, .{}, arg);
    }

    pub fn getIntAttribute(self: *Self, attribute: [:0]const u8) i32 {
        return c.getIntAttribute(self, attribute, .{});
    }

    pub fn setBoolAttribute(self: *Self, attribute: [:0]const u8, arg: bool) void {
        c.setBoolAttribute(self, attribute, .{}, arg);
    }

    pub fn getBoolAttribute(self: *Self, attribute: [:0]const u8) bool {
        return c.getBoolAttribute(self, attribute, .{});
    }

    pub fn getPtrAttribute(handle: *Self, comptime T: type, attribute: [:0]const u8) ?*T {
        return c.getPtrAttribute(T, handle, attribute, .{});
    }

    pub fn setPtrAttribute(handle: *Self, comptime T: type, attribute: [:0]const u8, value: ?*T) void {
        c.setPtrAttribute(T, handle, attribute, .{}, value);
    }

    ///
    ///
    pub fn getDialog(self: *Self) ?*iup.Dialog {
        if (c.IupGetDialog(c.getHandle(self))) |handle| {
            return c.fromHandle(iup.Dialog, handle);
        } else {
            return null;
        }
    }

    ///
    /// Returns the the child element that has the NAME attribute equals to the given value on the same dialog hierarchy.
    /// Works also for children of a menu that is associated with a dialog.
    pub fn getDialogChild(self: *Self, byName: [:0]const u8) ?Element {
        var child = c.IupGetDialogChild(c.getHandle(self), c.toCStr(byName)) orelse return null;
        var className = c.fromCStr(c.IupGetClassName(child));

        return Element.fromClassName(className, child);
    }

    ///
    /// Updates the size and layout of all controls in the same dialog.
    /// To be used after changing size attributes, or attributes that affect the size of the control. Can be used for any element inside a dialog, but the layout of the dialog and all controls will be updated. It can change the layout of all the controls inside the dialog because of the dynamic layout positioning.
    pub fn refresh(self: *Self) void {
        try Impl(Self).refresh(self);
    }

    pub fn getUserSize(self: *Self) Size {
        var str = c.getStrAttribute(self, "USERSIZE", .{});
        return Size.parse(str);
    }

    pub fn setUserSize(self: *Self, width: ?i32, height: ?i32) void {
        var buffer: [128]u8 = undefined;
        var value = Size.intIntToString(&buffer, width, height);
        c.setStrAttribute(self, "USERSIZE", .{}, value);
    }

    pub fn getFontStyle(self: *Self) [:0]const u8 {
        return c.getStrAttribute(self, "FONTSTYLE", .{});
    }

    pub fn setFontStyle(self: *Self, arg: [:0]const u8) void {
        c.setStrAttribute(self, "FONTSTYLE", .{}, arg);
    }

    pub fn getFontSize(self: *Self) i32 {
        return c.getIntAttribute(self, "FONTSIZE", .{});
    }

    pub fn setFontSize(self: *Self, arg: i32) void {
        c.setIntAttribute(self, "FONTSIZE", .{}, arg);
    }

    pub fn getExpandWeight(self: *Self) f64 {
        return c.getDoubleAttribute(self, "EXPANDWEIGHT", .{});
    }

    pub fn setExpandWeight(self: *Self, arg: f64) void {
        c.setDoubleAttribute(self, "EXPANDWEIGHT", .{}, arg);
    }

    pub fn getMaxSize(self: *Self) Size {
        var str = c.getStrAttribute(self, "MAXSIZE", .{});
        return Size.parse(str);
    }

    pub fn setMaxSize(self: *Self, width: ?i32, height: ?i32) void {
        var buffer: [128]u8 = undefined;
        var value = Size.intIntToString(&buffer, width, height);
        c.setStrAttribute(self, "MAXSIZE", .{}, value);
    }

    pub fn getActive(self: *Self) bool {
        return c.getBoolAttribute(self, "ACTIVE", .{});
    }

    pub fn setActive(self: *Self, arg: bool) void {
        c.setBoolAttribute(self, "ACTIVE", .{}, arg);
    }

    pub fn getNTheme(self: *Self) [:0]const u8 {
        return c.getStrAttribute(self, "NTHEME", .{});
    }

    pub fn setNTheme(self: *Self, arg: [:0]const u8) void {
        c.setStrAttribute(self, "NTHEME", .{}, arg);
    }

    pub fn getNaturalSize(self: *Self) Size {
        var str = c.getStrAttribute(self, "NATURALSIZE", .{});
        return Size.parse(str);
    }

    pub fn getVisible(self: *Self) bool {
        return c.getBoolAttribute(self, "VISIBLE", .{});
    }

    pub fn setVisible(self: *Self, arg: bool) void {
        c.setBoolAttribute(self, "VISIBLE", .{}, arg);
    }

    pub fn getFontFace(self: *Self) [:0]const u8 {
        return c.getStrAttribute(self, "FONTFACE", .{});
    }

    pub fn setFontFace(self: *Self, arg: [:0]const u8) void {
        c.setStrAttribute(self, "FONTFACE", .{}, arg);
    }

    pub fn getPropagateFocus(self: *Self) bool {
        return c.getBoolAttribute(self, "PROPAGATEFOCUS", .{});
    }

    pub fn setPropagateFocus(self: *Self, arg: bool) void {
        c.setBoolAttribute(self, "PROPAGATEFOCUS", .{}, arg);
    }

    pub fn getCharSize(self: *Self) Size {
        var str = c.getStrAttribute(self, "CHARSIZE", .{});
        return Size.parse(str);
    }

    pub fn getHandleName(self: *Self) [:0]const u8 {
        return c.getStrAttribute(self, "HANDLENAME", .{});
    }

    pub fn setHandleName(self: *Self, arg: [:0]const u8) void {
        c.setStrAttribute(self, "HANDLENAME", .{}, arg);
    }


    /// 
    /// SIZE, RASTERSIZE, EXPAND, FONT, POSITION, MINSIZE, MAXSIZE, THEME: also accepted.
    pub fn getSize(self: *Self) Size {
        var str = c.getStrAttribute(self, "SIZE", .{});
        return Size.parse(str);
    }


    /// 
    /// SIZE, RASTERSIZE, EXPAND, FONT, POSITION, MINSIZE, MAXSIZE, THEME: also accepted.
    pub fn setSize(self: *Self, width: ?i32, height: ?i32) void {
        var buffer: [128]u8 = undefined;
        var value = Size.intIntToString(&buffer, width, height);
        c.setStrAttribute(self, "SIZE", .{}, value);
    }

    pub fn getNormalizerGroup(self: *Self) [:0]const u8 {
        return c.getStrAttribute(self, "NORMALIZERGROUP", .{});
    }

    pub fn setNormalizerGroup(self: *Self, arg: [:0]const u8) void {
        c.setStrAttribute(self, "NORMALIZERGROUP", .{}, arg);
    }

    pub fn getFont(self: *Self) [:0]const u8 {
        return c.getStrAttribute(self, "FONT", .{});
    }

    pub fn setFont(self: *Self, arg: [:0]const u8) void {
        c.setStrAttribute(self, "FONT", .{}, arg);
    }

    pub fn getName(self: *Self) [:0]const u8 {
        return c.getStrAttribute(self, "NAME", .{});
    }

    pub fn setName(self: *Self, arg: [:0]const u8) void {
        c.setStrAttribute(self, "NAME", .{}, arg);
    }

    pub fn getExpand(self: *Self) ?Expand {
        var ret = c.getStrAttribute(self, "EXPAND", .{});

        if (std.ascii.eqlIgnoreCase("YES", ret)) return .Yes;
        if (std.ascii.eqlIgnoreCase("HORIZONTAL", ret)) return .Horizontal;
        if (std.ascii.eqlIgnoreCase("VERTICAL", ret)) return .Vertical;
        if (std.ascii.eqlIgnoreCase("HORIZONTALFREE", ret)) return .HorizontalFree;
        if (std.ascii.eqlIgnoreCase("VERTICALFREE", ret)) return .VerticalFree;
        if (std.ascii.eqlIgnoreCase("NO", ret)) return .No;
        return null;
    }

    pub fn setExpand(self: *Self, arg: ?Expand) void {
        if (arg) |value| switch (value) {
            .Yes => c.setStrAttribute(self, "EXPAND", .{}, "YES"),
            .Horizontal => c.setStrAttribute(self, "EXPAND", .{}, "HORIZONTAL"),
            .Vertical => c.setStrAttribute(self, "EXPAND", .{}, "VERTICAL"),
            .HorizontalFree => c.setStrAttribute(self, "EXPAND", .{}, "HORIZONTALFREE"),
            .VerticalFree => c.setStrAttribute(self, "EXPAND", .{}, "VERTICALFREE"),
            .No => c.setStrAttribute(self, "EXPAND", .{}, "NO"),
        } else {
            c.clearAttribute(self, "EXPAND", .{});
        }
    }

    pub fn getCanFocus(self: *Self) bool {
        return c.getBoolAttribute(self, "CANFOCUS", .{});
    }

    pub fn setCanFocus(self: *Self, arg: bool) void {
        c.setBoolAttribute(self, "CANFOCUS", .{}, arg);
    }

    pub fn getRasterSize(self: *Self) Size {
        var str = c.getStrAttribute(self, "RASTERSIZE", .{});
        return Size.parse(str);
    }

    pub fn setRasterSize(self: *Self, width: ?i32, height: ?i32) void {
        var buffer: [128]u8 = undefined;
        var value = Size.intIntToString(&buffer, width, height);
        c.setStrAttribute(self, "RASTERSIZE", .{}, value);
    }

    pub fn getFloating(self: *Self) ?Floating {
        var ret = c.getStrAttribute(self, "FLOATING", .{});

        if (std.ascii.eqlIgnoreCase("YES", ret)) return .Yes;
        if (std.ascii.eqlIgnoreCase("IGNORE", ret)) return .Ignore;
        if (std.ascii.eqlIgnoreCase("NO", ret)) return .No;
        return null;
    }

    pub fn setFloating(self: *Self, arg: ?Floating) void {
        if (arg) |value| switch (value) {
            .Yes => c.setStrAttribute(self, "FLOATING", .{}, "YES"),
            .Ignore => c.setStrAttribute(self, "FLOATING", .{}, "IGNORE"),
            .No => c.setStrAttribute(self, "FLOATING", .{}, "NO"),
        } else {
            c.clearAttribute(self, "FLOATING", .{});
        }
    }

    pub fn getTheme(self: *Self) [:0]const u8 {
        return c.getStrAttribute(self, "THEME", .{});
    }

    pub fn setTheme(self: *Self, arg: [:0]const u8) void {
        c.setStrAttribute(self, "THEME", .{}, arg);
    }


    /// 
    /// WID (read-only): returns -1 if mapped.
    pub fn getWId(self: *Self) i32 {
        return c.getIntAttribute(self, "WID", .{});
    }

    pub fn getMinSize(self: *Self) Size {
        var str = c.getStrAttribute(self, "MINSIZE", .{});
        return Size.parse(str);
    }

    pub fn setMinSize(self: *Self, width: ?i32, height: ?i32) void {
        var buffer: [128]u8 = undefined;
        var value = Size.intIntToString(&buffer, width, height);
        c.setStrAttribute(self, "MINSIZE", .{}, value);
    }

    pub fn getPosition(self: *Self) iup.XYPos {
        var str = c.getStrAttribute(self, "POSITION", .{});
        return iup.XYPos.parse(str, ',');
    }

    pub fn setPosition(self: *Self, x: i32, y: i32) void {
        var buffer: [128]u8 = undefined;
        var value = iup.XYPos.intIntToString(&buffer, x, y, ',');
        c.setStrAttribute(self, "POSITION", .{}, value);
    }

    pub fn setLDestroyCallback(self: *Self, callback: ?OnLDestroyFn) void {
        const Handler = CallbackHandler(Self, OnLDestroyFn, "LDESTROY_CB");
        Handler.setCallback(self, callback);
    }

    /// 
    /// DESTROY_CB DESTROY_CB Called right before an element is destroyed.
    /// Callback int function(Ihandle *ih); [in C] ih:destroy_cb() -> (ret: number)
    /// [in Lua] ih: identifier of the element that activated the event.
    /// Notes If the dialog is visible then it is hidden before it is destroyed.
    /// The callback will be called right after it is hidden.
    /// The callback will be called before all other destroy procedures.
    /// For instance, if the element has children then it is called before the
    /// children are destroyed.
    /// For language binding implementations use the callback name "LDESTROY_CB" to
    /// release memory allocated by the binding for the element.
    /// Also the callback will be called before the language callback.
    /// Affects All.
    pub fn setDestroyCallback(self: *Self, callback: ?OnDestroyFn) void {
        const Handler = CallbackHandler(Self, OnDestroyFn, "DESTROY_CB");
        Handler.setCallback(self, callback);
    }

    /// 
    /// MAP_CB MAP_CB Called right after an element is mapped and its attributes
    /// updated in IupMap.
    /// When the element is a dialog, it is called after the layout is updated.
    /// For all other elements is called before the layout is updated, so the
    /// element current size will still be 0x0 during MAP_CB (since 3.14).
    /// Callback int function(Ihandle *ih); [in C] ih:map_cb() -> (ret: number) [in
    /// Lua] ih: identifier of the element that activated the event.
    /// Affects All that have a native representation.
    pub fn setMapCallback(self: *Self, callback: ?OnMapFn) void {
        const Handler = CallbackHandler(Self, OnMapFn, "MAP_CB");
        Handler.setCallback(self, callback);
    }

    pub fn setPostMessageCallback(self: *Self, callback: ?OnPostMessageFn) void {
        const Handler = CallbackHandler(Self, OnPostMessageFn, "POSTMESSAGE_CB");
        Handler.setCallback(self, callback);
    }

    /// 
    /// UNMAP_CB UNMAP_CB Called right before an element is unmapped.
    /// Callback int function(Ihandle *ih); [in C] ih:unmap_cb() -> (ret: number)
    /// [in Lua] ih: identifier of the element that activated the event.
    /// Affects All that have a native representation.
    pub fn setUnmapCallback(self: *Self, callback: ?OnUnmapFn) void {
        const Handler = CallbackHandler(Self, OnUnmapFn, "UNMAP_CB");
        Handler.setCallback(self, callback);
    }
};

test "Space UserSize" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.Space.init().setUserSize(9, 10).unwrap());
    defer item.deinit();

    var ret = item.getUserSize();

    try std.testing.expect(ret.width != null and ret.width.? == 9 and ret.height != null and ret.height.? == 10);
}

test "Space FontStyle" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.Space.init().setFontStyle("Hello").unwrap());
    defer item.deinit();

    var ret = item.getFontStyle();

    try std.testing.expect(std.mem.eql(u8, ret, "Hello"));
}

test "Space FontSize" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.Space.init().setFontSize(42).unwrap());
    defer item.deinit();

    var ret = item.getFontSize();

    try std.testing.expect(ret == 42);
}

test "Space ExpandWeight" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.Space.init().setExpandWeight(3.14).unwrap());
    defer item.deinit();

    var ret = item.getExpandWeight();

    try std.testing.expect(ret == @as(f64, 3.14));
}

test "Space MaxSize" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.Space.init().setMaxSize(9, 10).unwrap());
    defer item.deinit();

    var ret = item.getMaxSize();

    try std.testing.expect(ret.width != null and ret.width.? == 9 and ret.height != null and ret.height.? == 10);
}

test "Space Active" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.Space.init().setActive(true).unwrap());
    defer item.deinit();

    var ret = item.getActive();

    try std.testing.expect(ret == true);
}

test "Space NTheme" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.Space.init().setNTheme("Hello").unwrap());
    defer item.deinit();

    var ret = item.getNTheme();

    try std.testing.expect(std.mem.eql(u8, ret, "Hello"));
}

test "Space Visible" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.Space.init().setVisible(true).unwrap());
    defer item.deinit();

    var ret = item.getVisible();

    try std.testing.expect(ret == true);
}

test "Space FontFace" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.Space.init().setFontFace("Hello").unwrap());
    defer item.deinit();

    var ret = item.getFontFace();

    try std.testing.expect(std.mem.eql(u8, ret, "Hello"));
}

test "Space PropagateFocus" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.Space.init().setPropagateFocus(true).unwrap());
    defer item.deinit();

    var ret = item.getPropagateFocus();

    try std.testing.expect(ret == true);
}

test "Space HandleName" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.Space.init().setHandleName("Hello").unwrap());
    defer item.deinit();

    var ret = item.getHandleName();

    try std.testing.expect(std.mem.eql(u8, ret, "Hello"));
}

test "Space Size" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.Space.init().setSize(9, 10).unwrap());
    defer item.deinit();

    var ret = item.getSize();

    try std.testing.expect(ret.width != null and ret.width.? == 9 and ret.height != null and ret.height.? == 10);
}

test "Space NormalizerGroup" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.Space.init().setNormalizerGroup("Hello").unwrap());
    defer item.deinit();

    var ret = item.getNormalizerGroup();

    try std.testing.expect(std.mem.eql(u8, ret, "Hello"));
}

test "Space Font" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.Space.init().setFont("Hello").unwrap());
    defer item.deinit();

    var ret = item.getFont();

    try std.testing.expect(std.mem.eql(u8, ret, "Hello"));
}

test "Space Name" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.Space.init().setName("Hello").unwrap());
    defer item.deinit();

    var ret = item.getName();

    try std.testing.expect(std.mem.eql(u8, ret, "Hello"));
}

test "Space Expand" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.Space.init().setExpand(.Yes).unwrap());
    defer item.deinit();

    var ret = item.getExpand();

    try std.testing.expect(ret != null and ret.? == .Yes);
}

test "Space CanFocus" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.Space.init().setCanFocus(true).unwrap());
    defer item.deinit();

    var ret = item.getCanFocus();

    try std.testing.expect(ret == true);
}

test "Space RasterSize" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.Space.init().setRasterSize(9, 10).unwrap());
    defer item.deinit();

    var ret = item.getRasterSize();

    try std.testing.expect(ret.width != null and ret.width.? == 9 and ret.height != null and ret.height.? == 10);
}

test "Space Floating" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.Space.init().setFloating(.Yes).unwrap());
    defer item.deinit();

    var ret = item.getFloating();

    try std.testing.expect(ret != null and ret.? == .Yes);
}

test "Space Theme" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.Space.init().setTheme("Hello").unwrap());
    defer item.deinit();

    var ret = item.getTheme();

    try std.testing.expect(std.mem.eql(u8, ret, "Hello"));
}

test "Space MinSize" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.Space.init().setMinSize(9, 10).unwrap());
    defer item.deinit();

    var ret = item.getMinSize();

    try std.testing.expect(ret.width != null and ret.width.? == 9 and ret.height != null and ret.height.? == 10);
}

test "Space Position" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.Space.init().setPosition(9, 10).unwrap());
    defer item.deinit();

    var ret = item.getPosition();

    try std.testing.expect(ret.x == 9 and ret.y == 10);
}
