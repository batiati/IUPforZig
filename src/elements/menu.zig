// This code was generated by a tool.
// IUP Metadata Code Generator
// https://github.com/batiati/IUPMetadata
//
//
// Changes to this file may cause incorrect behavior and will be lost if
// the code is regenerated.

const std = @import("std");

const interop = @import("../interop.zig");
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
/// Creates a menu element, which groups 3 types of interface elements: item,
/// submenu and separator.
/// Any other interface element defined inside a menu will be an error.
pub const Menu = opaque {
    pub const CLASS_NAME = "menu";
    const Self = @This();

    /// 
    /// MENUCLOSE_CB MENUCLOSE_CB Called just after the menu is closed.
    /// Callback int function(Ihandle *ih); [in C] ih:menuclose_cb() -> (ret:
    /// number) [in Lua] ih: identifier of the element that activated the event.
    /// Affects IupMenu
    pub const OnMenuCloseFn = fn (self: *Self) anyerror!void;

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
    /// OPEN_CB OPEN_CB Called just before the menu is opened.
    /// Callback int function(Ihandle *ih); [in C] ih:open_cb() -> (ret: number)
    /// [in Lua] ih: identifier of the element that activated the event.
    /// Affects IupMenu
    pub const OnOpenFn = fn (self: *Self) anyerror!void;

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
            Self.setBoolAttribute(self.ref, attributeName, arg);
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

        /// 
        /// BGCOLOR: the background color of the menu, affects all items in the menu.
        /// (since 3.0)
        pub fn setBgColor(self: *Initializer, rgb: iup.Rgb) Initializer {
            interop.setRgb(self.ref, "BGCOLOR", .{}, rgb);
            return self.*;
        }

        pub fn setName(self: *Initializer, arg: [:0]const u8) Initializer {
            interop.setStrAttribute(self.ref, "NAME", .{}, arg);
            return self.*;
        }

        /// 
        /// RADIO (non inheritable): enables the automatic toggle of one child item.
        /// When a child item is selected the other item is automatically deselected.
        /// The menu acts like a IupRadio for its children.
        /// Submenus and their children are not affected.
        pub fn setRadio(self: *Initializer, arg: bool) Initializer {
            interop.setBoolAttribute(self.ref, "RADIO", .{}, arg);
            return self.*;
        }

        /// 
        /// MENUCLOSE_CB MENUCLOSE_CB Called just after the menu is closed.
        /// Callback int function(Ihandle *ih); [in C] ih:menuclose_cb() -> (ret:
        /// number) [in Lua] ih: identifier of the element that activated the event.
        /// Affects IupMenu
        pub fn setMenuCloseCallback(self: *Initializer, callback: ?OnMenuCloseFn) Initializer {
            const Handler = CallbackHandler(Self, OnMenuCloseFn, "MENUCLOSE_CB");
            Handler.setCallback(self.ref, callback);
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
        /// OPEN_CB OPEN_CB Called just before the menu is opened.
        /// Callback int function(Ihandle *ih); [in C] ih:open_cb() -> (ret: number)
        /// [in Lua] ih: identifier of the element that activated the event.
        /// Affects IupMenu
        pub fn setOpenCallback(self: *Initializer, callback: ?OnOpenFn) Initializer {
            const Handler = CallbackHandler(Self, OnOpenFn, "OPEN_CB");
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

    pub fn setStrAttribute(self: *Self, attribute: [:0]const u8, arg: [:0]const u8) void {
        interop.setStrAttribute(self, attribute, .{}, arg);
    }

    pub fn getStrAttribute(self: *Self, attribute: [:0]const u8) [:0]const u8 {
        return interop.getStrAttribute(self, attribute, .{});
    }

    pub fn setIntAttribute(self: *Self, attribute: [:0]const u8, arg: i32) void {
        interop.setIntAttribute(self, attribute, .{}, arg);
    }

    pub fn getIntAttribute(self: *Self, attribute: [:0]const u8) i32 {
        return interop.getIntAttribute(self, attribute, .{});
    }

    pub fn setBoolAttribute(self: *Self, attribute: [:0]const u8, arg: bool) void {
        interop.setBoolAttribute(self, attribute, .{}, arg);
    }

    pub fn getBoolAttribute(self: *Self, attribute: [:0]const u8) bool {
        return interop.getBoolAttribute(self, attribute, .{});
    }

    pub fn getPtrAttribute(handle: *Self, comptime T: type, attribute: [:0]const u8) ?*T {
        return interop.getPtrAttribute(T, handle, attribute, .{});
    }

    pub fn setPtrAttribute(handle: *Self, comptime T: type, attribute: [:0]const u8, value: ?*T) void {
        interop.setPtrAttribute(T, handle, attribute, .{}, value);
    }

    ///
    /// Creates an interface element given its class name and parameters.
    /// After creation the element still needs to be attached to a container and mapped to the native system so it can be visible.
    pub fn init() Initializer {
        var handle = interop.create(Self);

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
        interop.destroy(self);
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

    pub fn popup(self: *Self, x: iup.DialogPosX, y: iup.DialogPosY) !void {
        try interop.popup(self, x, y);
    }

    pub fn hide(self: *Self) !void {
        try interop.hide(self);
    }

    ///
    ///
    pub fn getDialog(self: *Self) ?*iup.Dialog {
        return interop.getDialog(self);
    }

    ///
    /// Returns the the child element that has the NAME attribute equals to the given value on the same dialog hierarchy.
    /// Works also for children of a menu that is associated with a dialog.
    pub fn getDialogChild(self: *Self, byName: [:0]const u8) ?Element {
        return interop.getDialogChild(self, byName);
    }

    ///
    /// Updates the size and layout of all controls in the same dialog.
    /// To be used after changing size attributes, or attributes that affect the size of the control. Can be used for any element inside a dialog, but the layout of the dialog and all controls will be updated. It can change the layout of all the controls inside the dialog because of the dynamic layout positioning.
    pub fn refresh(self: *Self) void {
        Impl(Self).refresh(self);
    }

    /// 
    /// BGCOLOR: the background color of the menu, affects all items in the menu.
    /// (since 3.0)
    pub fn getBgColor(self: *Self) ?iup.Rgb {
        return interop.getRgb(self, "BGCOLOR", .{});
    }

    /// 
    /// BGCOLOR: the background color of the menu, affects all items in the menu.
    /// (since 3.0)
    pub fn setBgColor(self: *Self, rgb: iup.Rgb) void {
        interop.setRgb(self, "BGCOLOR", .{}, rgb);
    }

    pub fn getName(self: *Self) [:0]const u8 {
        return interop.getStrAttribute(self, "NAME", .{});
    }

    pub fn setName(self: *Self, arg: [:0]const u8) void {
        interop.setStrAttribute(self, "NAME", .{}, arg);
    }

    /// 
    /// WID (non inheritable): In Windows, returns the HMENU of the menu.
    pub fn getWId(self: *Self) i32 {
        return interop.getIntAttribute(self, "WID", .{});
    }

    /// 
    /// RADIO (non inheritable): enables the automatic toggle of one child item.
    /// When a child item is selected the other item is automatically deselected.
    /// The menu acts like a IupRadio for its children.
    /// Submenus and their children are not affected.
    pub fn getRadio(self: *Self) bool {
        return interop.getBoolAttribute(self, "RADIO", .{});
    }

    /// 
    /// RADIO (non inheritable): enables the automatic toggle of one child item.
    /// When a child item is selected the other item is automatically deselected.
    /// The menu acts like a IupRadio for its children.
    /// Submenus and their children are not affected.
    pub fn setRadio(self: *Self, arg: bool) void {
        interop.setBoolAttribute(self, "RADIO", .{}, arg);
    }

    /// 
    /// MENUCLOSE_CB MENUCLOSE_CB Called just after the menu is closed.
    /// Callback int function(Ihandle *ih); [in C] ih:menuclose_cb() -> (ret:
    /// number) [in Lua] ih: identifier of the element that activated the event.
    /// Affects IupMenu
    pub fn setMenuCloseCallback(self: *Self, callback: ?OnMenuCloseFn) void {
        const Handler = CallbackHandler(Self, OnMenuCloseFn, "MENUCLOSE_CB");
        Handler.setCallback(self, callback);
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
    /// OPEN_CB OPEN_CB Called just before the menu is opened.
    /// Callback int function(Ihandle *ih); [in C] ih:open_cb() -> (ret: number)
    /// [in Lua] ih: identifier of the element that activated the event.
    /// Affects IupMenu
    pub fn setOpenCallback(self: *Self, callback: ?OnOpenFn) void {
        const Handler = CallbackHandler(Self, OnOpenFn, "OPEN_CB");
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

test "Menu BgColor" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.Menu.init().setBgColor(.{ .r = 9, .g = 10, .b = 11 }).unwrap());
    defer item.deinit();

    var ret = item.getBgColor();

    try std.testing.expect(ret != null and ret.?.r == 9 and ret.?.g == 10 and ret.?.b == 11);
}

test "Menu Name" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.Menu.init().setName("Hello").unwrap());
    defer item.deinit();

    var ret = item.getName();

    try std.testing.expect(std.mem.eql(u8, ret, "Hello"));
}

test "Menu Radio" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.Menu.init().setRadio(true).unwrap());
    defer item.deinit();

    var ret = item.getRadio();

    try std.testing.expect(ret == true);
}
