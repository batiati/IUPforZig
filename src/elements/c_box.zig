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
/// Creates a void container for position elements in absolute coordinates.
/// It is a concrete layout container.
/// It does not have a native representation.
/// The IupCbox is equivalent of a IupVbox or IupHbox where all the children
/// have the FLOATING attribute set to YES, but children must use CX and CY
/// attributes instead of the POSITION attribute.
pub const CBox = opaque {
    pub const CLASS_NAME = "cbox";
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

    /// 
    /// EXPAND (non inheritable): The default value is "YES".
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

        pub fn setChildren(self: *Initializer, tuple: anytype) Initializer {
            if (self.last_error) |_| return self.*;

            Self.appendChildren(self.ref, tuple) catch |err| {
                self.last_error = err;
            };

            return self.*;
        }

        pub fn setUserSize(self: *Initializer, width: ?i32, height: ?i32) Initializer {
            var buffer: [128]u8 = undefined;
            var value = Size.intIntToString(&buffer, width, height);
            c.setStrAttribute(self.ref, "USERSIZE", void, void, value);
            return self.*;
        }

        pub fn setFontStyle(self: *Initializer, arg: [:0]const u8) Initializer {
            c.setStrAttribute(self.ref, "FONTSTYLE", void, void, arg);
            return self.*;
        }

        pub fn setFontSize(self: *Initializer, arg: i32) Initializer {
            c.setIntAttribute(self.ref, "FONTSIZE", void, void, arg);
            return self.*;
        }

        pub fn setExpandWeight(self: *Initializer, arg: f64) Initializer {
            c.setDoubleAttribute(self.ref, "EXPANDWEIGHT", void, void, arg);
            return self.*;
        }

        pub fn setMaxSize(self: *Initializer, width: ?i32, height: ?i32) Initializer {
            var buffer: [128]u8 = undefined;
            var value = Size.intIntToString(&buffer, width, height);
            c.setStrAttribute(self.ref, "MAXSIZE", void, void, value);
            return self.*;
        }

        pub fn setActive(self: *Initializer, arg: bool) Initializer {
            c.setBoolAttribute(self.ref, "ACTIVE", void, void, arg);
            return self.*;
        }

        pub fn setNTheme(self: *Initializer, arg: [:0]const u8) Initializer {
            c.setStrAttribute(self.ref, "NTHEME", void, void, arg);
            return self.*;
        }

        pub fn setVisible(self: *Initializer, arg: bool) Initializer {
            c.setBoolAttribute(self.ref, "VISIBLE", void, void, arg);
            return self.*;
        }

        pub fn setFontFace(self: *Initializer, arg: [:0]const u8) Initializer {
            c.setStrAttribute(self.ref, "FONTFACE", void, void, arg);
            return self.*;
        }

        pub fn setPropagateFocus(self: *Initializer, arg: bool) Initializer {
            c.setBoolAttribute(self.ref, "PROPAGATEFOCUS", void, void, arg);
            return self.*;
        }

        pub fn setHandleName(self: *Initializer, arg: [:0]const u8) Initializer {
            c.setStrAttribute(self.ref, "HANDLENAME", void, void, arg);
            return self.*;
        }


        /// 
        /// SIZE / RASTERSIZE (non inheritable): Must be defined for each child.
        /// If not defined for the box, then it will be the bounding box that includes
        /// all children in their position.
        pub fn setSize(self: *Initializer, width: ?i32, height: ?i32) Initializer {
            var buffer: [128]u8 = undefined;
            var value = Size.intIntToString(&buffer, width, height);
            c.setStrAttribute(self.ref, "SIZE", void, void, value);
            return self.*;
        }

        pub fn setNormalizerGroup(self: *Initializer, arg: [:0]const u8) Initializer {
            c.setStrAttribute(self.ref, "NORMALIZERGROUP", void, void, arg);
            return self.*;
        }


        /// 
        /// FONT, CLIENTSIZE, CLIENTOFFSET, POSITION, MINSIZE, MAXSIZE, THEME: also accepted.
        pub fn setFont(self: *Initializer, arg: [:0]const u8) Initializer {
            c.setStrAttribute(self.ref, "FONT", void, void, arg);
            return self.*;
        }

        pub fn setName(self: *Initializer, arg: [:0]const u8) Initializer {
            c.setStrAttribute(self.ref, "NAME", void, void, arg);
            return self.*;
        }


        /// 
        /// EXPAND (non inheritable): The default value is "YES".
        pub fn setExpand(self: *Initializer, arg: ?Expand) Initializer {
            if (arg) |value| switch (value) {
                .Yes => c.setStrAttribute(self.ref, "EXPAND", void, void, "YES"),
                .Horizontal => c.setStrAttribute(self.ref, "EXPAND", void, void, "HORIZONTAL"),
                .Vertical => c.setStrAttribute(self.ref, "EXPAND", void, void, "VERTICAL"),
                .HorizontalFree => c.setStrAttribute(self.ref, "EXPAND", void, void, "HORIZONTALFREE"),
                .VerticalFree => c.setStrAttribute(self.ref, "EXPAND", void, void, "VERTICALFREE"),
                .No => c.setStrAttribute(self.ref, "EXPAND", void, void, "NO"),
            } else {
                c.clearAttribute(self.ref, "EXPAND", void, void);
            }
            return self.*;
        }

        pub fn setCanFocus(self: *Initializer, arg: bool) Initializer {
            c.setBoolAttribute(self.ref, "CANFOCUS", void, void, arg);
            return self.*;
        }

        pub fn setRasterSize(self: *Initializer, width: ?i32, height: ?i32) Initializer {
            var buffer: [128]u8 = undefined;
            var value = Size.intIntToString(&buffer, width, height);
            c.setStrAttribute(self.ref, "RASTERSIZE", void, void, value);
            return self.*;
        }

        pub fn setFloating(self: *Initializer, arg: ?Floating) Initializer {
            if (arg) |value| switch (value) {
                .Yes => c.setStrAttribute(self.ref, "FLOATING", void, void, "YES"),
                .Ignore => c.setStrAttribute(self.ref, "FLOATING", void, void, "IGNORE"),
                .No => c.setStrAttribute(self.ref, "FLOATING", void, void, "NO"),
            } else {
                c.clearAttribute(self.ref, "FLOATING", void, void);
            }
            return self.*;
        }

        pub fn setTheme(self: *Initializer, arg: [:0]const u8) Initializer {
            c.setStrAttribute(self.ref, "THEME", void, void, arg);
            return self.*;
        }

        pub fn setMinSize(self: *Initializer, width: ?i32, height: ?i32) Initializer {
            var buffer: [128]u8 = undefined;
            var value = Size.intIntToString(&buffer, width, height);
            c.setStrAttribute(self.ref, "MINSIZE", void, void, value);
            return self.*;
        }

        pub fn setPosition(self: *Initializer, x: i32, y: i32) Initializer {
            var buffer: [128]u8 = undefined;
            var value = iup.XYPos.intIntToString(&buffer, x, y, ',');
            c.setStrAttribute(self.ref, "POSITION", void, void, value);
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

    pub fn setStrAttribute(self: *Self, attributeName: [:0]const u8, arg: [:0]const u8) void {
        c.setStrAttribute(self, attributeName, void, void, arg);
    }

    pub fn getStrAttribute(self: *Self, attributeName: [:0]const u8) [:0]const u8 {
        return c.getStrAttribute(self, attributeName, void, void);
    }

    pub fn setIntAttribute(self: *Self, attributeName: [:0]const u8, arg: i32) void {
        c.setIntAttribute(self, attributeName, void, void, arg);
    }

    pub fn getIntAttribute(self: *Self, attributeName: [:0]const u8) i32 {
        return c.getIntAttribute(self, attributeName, void, void);
    }

    pub fn setBoolAttribute(self: *Self, attributeName: [:0]const u8, arg: bool) void {
        c.setBoolAttribute(self, attributeName, void, void, arg);
    }

    pub fn getBoolAttribute(self: *Self, attributeName: [:0]const u8) bool {
        return c.getBoolAttribute(self, attributeName, void, void);
    }

    pub fn getPtrAttribute(handle: *Self, comptime T: type, attributeName: [:0]const u8) ?*T {
        return c.getPtrAttribute(T, handle, attributeName, void, void);
    }

    pub fn setPtrAttribute(handle: *Self, comptime T: type, attributeName: [:0]const u8, value: ?*T) void {
        c.setPtrAttribute(T, handle, attributeName, void, void, value);
    }

    ///
    /// Adds a tuple of children
    pub fn appendChildren(self: *Self, tuple: anytype) !void {
        try Impl(Self).appendChildren(self, tuple);
    }

    ///
    /// Appends a child on this container
    /// child must be an Element or
    pub fn appendChild(self: *Self, child: anytype) !void {
        try Impl(Self).appendChild(self, child);
    }

    ///
    /// Returns a iterator for children elements.
    pub fn children(self: *Self) ChildrenIterator {
        return ChildrenIterator.init(self);
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
        var str = c.getStrAttribute(self, "USERSIZE", void, void);
        return Size.parse(str);
    }

    pub fn setUserSize(self: *Self, width: ?i32, height: ?i32) void {
        var buffer: [128]u8 = undefined;
        var value = Size.intIntToString(&buffer, width, height);
        c.setStrAttribute(self, "USERSIZE", void, void, value);
    }

    pub fn getFontStyle(self: *Self) [:0]const u8 {
        return c.getStrAttribute(self, "FONTSTYLE", void, void);
    }

    pub fn setFontStyle(self: *Self, arg: [:0]const u8) void {
        c.setStrAttribute(self, "FONTSTYLE", void, void, arg);
    }

    pub fn getFontSize(self: *Self) i32 {
        return c.getIntAttribute(self, "FONTSIZE", void, void);
    }

    pub fn setFontSize(self: *Self, arg: i32) void {
        c.setIntAttribute(self, "FONTSIZE", void, void, arg);
    }

    pub fn getExpandWeight(self: *Self) f64 {
        return c.getDoubleAttribute(self, "EXPANDWEIGHT", void, void);
    }

    pub fn setExpandWeight(self: *Self, arg: f64) void {
        c.setDoubleAttribute(self, "EXPANDWEIGHT", void, void, arg);
    }

    pub fn getMaxSize(self: *Self) Size {
        var str = c.getStrAttribute(self, "MAXSIZE", void, void);
        return Size.parse(str);
    }

    pub fn setMaxSize(self: *Self, width: ?i32, height: ?i32) void {
        var buffer: [128]u8 = undefined;
        var value = Size.intIntToString(&buffer, width, height);
        c.setStrAttribute(self, "MAXSIZE", void, void, value);
    }

    pub fn getActive(self: *Self) bool {
        return c.getBoolAttribute(self, "ACTIVE", void, void);
    }

    pub fn setActive(self: *Self, arg: bool) void {
        c.setBoolAttribute(self, "ACTIVE", void, void, arg);
    }

    pub fn getNTheme(self: *Self) [:0]const u8 {
        return c.getStrAttribute(self, "NTHEME", void, void);
    }

    pub fn setNTheme(self: *Self, arg: [:0]const u8) void {
        c.setStrAttribute(self, "NTHEME", void, void, arg);
    }

    pub fn getNaturalSize(self: *Self) Size {
        var str = c.getStrAttribute(self, "NATURALSIZE", void, void);
        return Size.parse(str);
    }

    pub fn getVisible(self: *Self) bool {
        return c.getBoolAttribute(self, "VISIBLE", void, void);
    }

    pub fn setVisible(self: *Self, arg: bool) void {
        c.setBoolAttribute(self, "VISIBLE", void, void, arg);
    }

    pub fn getClientOffset(self: *Self) Size {
        var str = c.getStrAttribute(self, "CLIENTOFFSET", void, void);
        return Size.parse(str);
    }

    pub fn getFontFace(self: *Self) [:0]const u8 {
        return c.getStrAttribute(self, "FONTFACE", void, void);
    }

    pub fn setFontFace(self: *Self, arg: [:0]const u8) void {
        c.setStrAttribute(self, "FONTFACE", void, void, arg);
    }

    pub fn getPropagateFocus(self: *Self) bool {
        return c.getBoolAttribute(self, "PROPAGATEFOCUS", void, void);
    }

    pub fn setPropagateFocus(self: *Self, arg: bool) void {
        c.setBoolAttribute(self, "PROPAGATEFOCUS", void, void, arg);
    }

    pub fn getCharSize(self: *Self) Size {
        var str = c.getStrAttribute(self, "CHARSIZE", void, void);
        return Size.parse(str);
    }

    pub fn getHandleName(self: *Self) [:0]const u8 {
        return c.getStrAttribute(self, "HANDLENAME", void, void);
    }

    pub fn setHandleName(self: *Self, arg: [:0]const u8) void {
        c.setStrAttribute(self, "HANDLENAME", void, void, arg);
    }


    /// 
    /// SIZE / RASTERSIZE (non inheritable): Must be defined for each child.
    /// If not defined for the box, then it will be the bounding box that includes
    /// all children in their position.
    pub fn getSize(self: *Self) Size {
        var str = c.getStrAttribute(self, "SIZE", void, void);
        return Size.parse(str);
    }


    /// 
    /// SIZE / RASTERSIZE (non inheritable): Must be defined for each child.
    /// If not defined for the box, then it will be the bounding box that includes
    /// all children in their position.
    pub fn setSize(self: *Self, width: ?i32, height: ?i32) void {
        var buffer: [128]u8 = undefined;
        var value = Size.intIntToString(&buffer, width, height);
        c.setStrAttribute(self, "SIZE", void, void, value);
    }

    pub fn getNormalizerGroup(self: *Self) [:0]const u8 {
        return c.getStrAttribute(self, "NORMALIZERGROUP", void, void);
    }

    pub fn setNormalizerGroup(self: *Self, arg: [:0]const u8) void {
        c.setStrAttribute(self, "NORMALIZERGROUP", void, void, arg);
    }


    /// 
    /// FONT, CLIENTSIZE, CLIENTOFFSET, POSITION, MINSIZE, MAXSIZE, THEME: also accepted.
    pub fn getFont(self: *Self) [:0]const u8 {
        return c.getStrAttribute(self, "FONT", void, void);
    }


    /// 
    /// FONT, CLIENTSIZE, CLIENTOFFSET, POSITION, MINSIZE, MAXSIZE, THEME: also accepted.
    pub fn setFont(self: *Self, arg: [:0]const u8) void {
        c.setStrAttribute(self, "FONT", void, void, arg);
    }

    pub fn getName(self: *Self) [:0]const u8 {
        return c.getStrAttribute(self, "NAME", void, void);
    }

    pub fn setName(self: *Self, arg: [:0]const u8) void {
        c.setStrAttribute(self, "NAME", void, void, arg);
    }


    /// 
    /// EXPAND (non inheritable): The default value is "YES".
    pub fn getExpand(self: *Self) ?Expand {
        var ret = c.getStrAttribute(self, "EXPAND", void, void);

        if (std.ascii.eqlIgnoreCase("YES", ret)) return .Yes;
        if (std.ascii.eqlIgnoreCase("HORIZONTAL", ret)) return .Horizontal;
        if (std.ascii.eqlIgnoreCase("VERTICAL", ret)) return .Vertical;
        if (std.ascii.eqlIgnoreCase("HORIZONTALFREE", ret)) return .HorizontalFree;
        if (std.ascii.eqlIgnoreCase("VERTICALFREE", ret)) return .VerticalFree;
        if (std.ascii.eqlIgnoreCase("NO", ret)) return .No;
        return null;
    }


    /// 
    /// EXPAND (non inheritable): The default value is "YES".
    pub fn setExpand(self: *Self, arg: ?Expand) void {
        if (arg) |value| switch (value) {
            .Yes => c.setStrAttribute(self, "EXPAND", void, void, "YES"),
            .Horizontal => c.setStrAttribute(self, "EXPAND", void, void, "HORIZONTAL"),
            .Vertical => c.setStrAttribute(self, "EXPAND", void, void, "VERTICAL"),
            .HorizontalFree => c.setStrAttribute(self, "EXPAND", void, void, "HORIZONTALFREE"),
            .VerticalFree => c.setStrAttribute(self, "EXPAND", void, void, "VERTICALFREE"),
            .No => c.setStrAttribute(self, "EXPAND", void, void, "NO"),
        } else {
            c.clearAttribute(self, "EXPAND", void, void);
        }
    }

    pub fn getCanFocus(self: *Self) bool {
        return c.getBoolAttribute(self, "CANFOCUS", void, void);
    }

    pub fn setCanFocus(self: *Self, arg: bool) void {
        c.setBoolAttribute(self, "CANFOCUS", void, void, arg);
    }

    pub fn getRasterSize(self: *Self) Size {
        var str = c.getStrAttribute(self, "RASTERSIZE", void, void);
        return Size.parse(str);
    }

    pub fn setRasterSize(self: *Self, width: ?i32, height: ?i32) void {
        var buffer: [128]u8 = undefined;
        var value = Size.intIntToString(&buffer, width, height);
        c.setStrAttribute(self, "RASTERSIZE", void, void, value);
    }

    pub fn getFloating(self: *Self) ?Floating {
        var ret = c.getStrAttribute(self, "FLOATING", void, void);

        if (std.ascii.eqlIgnoreCase("YES", ret)) return .Yes;
        if (std.ascii.eqlIgnoreCase("IGNORE", ret)) return .Ignore;
        if (std.ascii.eqlIgnoreCase("NO", ret)) return .No;
        return null;
    }

    pub fn setFloating(self: *Self, arg: ?Floating) void {
        if (arg) |value| switch (value) {
            .Yes => c.setStrAttribute(self, "FLOATING", void, void, "YES"),
            .Ignore => c.setStrAttribute(self, "FLOATING", void, void, "IGNORE"),
            .No => c.setStrAttribute(self, "FLOATING", void, void, "NO"),
        } else {
            c.clearAttribute(self, "FLOATING", void, void);
        }
    }

    pub fn getTheme(self: *Self) [:0]const u8 {
        return c.getStrAttribute(self, "THEME", void, void);
    }

    pub fn setTheme(self: *Self, arg: [:0]const u8) void {
        c.setStrAttribute(self, "THEME", void, void, arg);
    }


    /// 
    /// WID (read-only): returns -1 if mapped.
    pub fn getWId(self: *Self) i32 {
        return c.getIntAttribute(self, "WID", void, void);
    }

    pub fn getMinSize(self: *Self) Size {
        var str = c.getStrAttribute(self, "MINSIZE", void, void);
        return Size.parse(str);
    }

    pub fn setMinSize(self: *Self, width: ?i32, height: ?i32) void {
        var buffer: [128]u8 = undefined;
        var value = Size.intIntToString(&buffer, width, height);
        c.setStrAttribute(self, "MINSIZE", void, void, value);
    }

    pub fn getPosition(self: *Self) iup.XYPos {
        var str = c.getStrAttribute(self, "POSITION", void, void);
        return iup.XYPos.parse(str, ',');
    }

    pub fn setPosition(self: *Self, x: i32, y: i32) void {
        var buffer: [128]u8 = undefined;
        var value = iup.XYPos.intIntToString(&buffer, x, y, ',');
        c.setStrAttribute(self, "POSITION", void, void, value);
    }

    pub fn getClientSize(self: *Self) Size {
        var str = c.getStrAttribute(self, "CLIENTSIZE", void, void);
        return Size.parse(str);
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

test "CBox UserSize" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.CBox.init().setUserSize(9, 10).unwrap());
    defer item.deinit();

    var ret = item.getUserSize();

    try std.testing.expect(ret.width != null and ret.width.? == 9 and ret.height != null and ret.height.? == 10);
}

test "CBox FontStyle" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.CBox.init().setFontStyle("Hello").unwrap());
    defer item.deinit();

    var ret = item.getFontStyle();

    try std.testing.expect(std.mem.eql(u8, ret, "Hello"));
}

test "CBox FontSize" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.CBox.init().setFontSize(42).unwrap());
    defer item.deinit();

    var ret = item.getFontSize();

    try std.testing.expect(ret == 42);
}

test "CBox ExpandWeight" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.CBox.init().setExpandWeight(3.14).unwrap());
    defer item.deinit();

    var ret = item.getExpandWeight();

    try std.testing.expect(ret == @as(f64, 3.14));
}

test "CBox MaxSize" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.CBox.init().setMaxSize(9, 10).unwrap());
    defer item.deinit();

    var ret = item.getMaxSize();

    try std.testing.expect(ret.width != null and ret.width.? == 9 and ret.height != null and ret.height.? == 10);
}

test "CBox Active" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.CBox.init().setActive(true).unwrap());
    defer item.deinit();

    var ret = item.getActive();

    try std.testing.expect(ret == true);
}

test "CBox NTheme" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.CBox.init().setNTheme("Hello").unwrap());
    defer item.deinit();

    var ret = item.getNTheme();

    try std.testing.expect(std.mem.eql(u8, ret, "Hello"));
}

test "CBox Visible" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.CBox.init().setVisible(true).unwrap());
    defer item.deinit();

    var ret = item.getVisible();

    try std.testing.expect(ret == true);
}

test "CBox FontFace" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.CBox.init().setFontFace("Hello").unwrap());
    defer item.deinit();

    var ret = item.getFontFace();

    try std.testing.expect(std.mem.eql(u8, ret, "Hello"));
}

test "CBox PropagateFocus" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.CBox.init().setPropagateFocus(true).unwrap());
    defer item.deinit();

    var ret = item.getPropagateFocus();

    try std.testing.expect(ret == true);
}

test "CBox HandleName" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.CBox.init().setHandleName("Hello").unwrap());
    defer item.deinit();

    var ret = item.getHandleName();

    try std.testing.expect(std.mem.eql(u8, ret, "Hello"));
}

test "CBox Size" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.CBox.init().setSize(9, 10).unwrap());
    defer item.deinit();

    var ret = item.getSize();

    try std.testing.expect(ret.width != null and ret.width.? == 9 and ret.height != null and ret.height.? == 10);
}

test "CBox NormalizerGroup" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.CBox.init().setNormalizerGroup("Hello").unwrap());
    defer item.deinit();

    var ret = item.getNormalizerGroup();

    try std.testing.expect(std.mem.eql(u8, ret, "Hello"));
}

test "CBox Font" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.CBox.init().setFont("Hello").unwrap());
    defer item.deinit();

    var ret = item.getFont();

    try std.testing.expect(std.mem.eql(u8, ret, "Hello"));
}

test "CBox Name" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.CBox.init().setName("Hello").unwrap());
    defer item.deinit();

    var ret = item.getName();

    try std.testing.expect(std.mem.eql(u8, ret, "Hello"));
}

test "CBox Expand" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.CBox.init().setExpand(.Yes).unwrap());
    defer item.deinit();

    var ret = item.getExpand();

    try std.testing.expect(ret != null and ret.? == .Yes);
}

test "CBox CanFocus" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.CBox.init().setCanFocus(true).unwrap());
    defer item.deinit();

    var ret = item.getCanFocus();

    try std.testing.expect(ret == true);
}

test "CBox RasterSize" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.CBox.init().setRasterSize(9, 10).unwrap());
    defer item.deinit();

    var ret = item.getRasterSize();

    try std.testing.expect(ret.width != null and ret.width.? == 9 and ret.height != null and ret.height.? == 10);
}

test "CBox Floating" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.CBox.init().setFloating(.Yes).unwrap());
    defer item.deinit();

    var ret = item.getFloating();

    try std.testing.expect(ret != null and ret.? == .Yes);
}

test "CBox Theme" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.CBox.init().setTheme("Hello").unwrap());
    defer item.deinit();

    var ret = item.getTheme();

    try std.testing.expect(std.mem.eql(u8, ret, "Hello"));
}

test "CBox MinSize" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.CBox.init().setMinSize(9, 10).unwrap());
    defer item.deinit();

    var ret = item.getMinSize();

    try std.testing.expect(ret.width != null and ret.width.? == 9 and ret.height != null and ret.height.? == 10);
}

test "CBox Position" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.CBox.init().setPosition(9, 10).unwrap());
    defer item.deinit();

    var ret = item.getPosition();

    try std.testing.expect(ret.x == 9 and ret.y == 10);
}
