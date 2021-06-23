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
/// Creates a menu item that, when selected, opens another menu.
pub const SubMenu = opaque {
    pub const CLASS_NAME = "submenu";
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
    /// HIGHLIGHT_CB HIGHLIGHT_CB Callback triggered every time the user selects an
    /// IupItem or IupSubmenu.
    /// Callback int function(Ihandle *ih); [in C] elem:highlight_cb() -> (ret:
    /// number) [in Lua] ih: identifier of the element that activated the event.
    /// Affects IupItem, IupSubmenu
    pub const OnHighlightFn = fn (self: *Self) anyerror!void;

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


        /// 
        /// ACTIVE, THEME: also accepted.
        pub fn setActive(self: *Initializer, arg: bool) Initializer {
            c.setBoolAttribute(self.ref, "ACTIVE", arg);
            return self.*;
        }


        /// 
        /// TITLE (non inheritable): Submenu Text.
        /// The "&" character can be used to define a mnemonic, the next character will
        /// be used as key.
        /// Use "&&" to show the "&" character instead on defining a mnemonic.
        pub fn setTitle(self: *Initializer, arg: [:0]const u8) Initializer {
            c.setStrAttribute(self.ref, "TITLE", arg);
            return self.*;
        }


        /// 
        /// IMAGE [Windows and GTK Only] (non inheritable): Image name of the submenu image.
        /// In Windows, an item in a menu bar cannot have a check mark.
        /// Ignored if submenu in a menu bar.
        /// A recommended size would be 16x16 to fit the image in the menu item.
        /// In Windows, if larger than the check mark area it will be cropped.
        /// (since 3.0)
        pub fn setImage(self: *Initializer, arg: [:0]const u8) Initializer {
            c.setStrAttribute(self.ref, "IMAGE", arg);
            return self.*;
        }

        pub fn setHandleName(self: *Initializer, arg: [:0]const u8) Initializer {
            c.setStrAttribute(self.ref, "HANDLENAME", arg);
            return self.*;
        }

        pub fn setBgColor(self: *Initializer, rgb: iup.Rgb) Initializer {
            c.setRgb(self.ref, "BGCOLOR", rgb);
            return self.*;
        }


        /// 
        /// KEY (non inheritable): Underlines a key character in the submenu title.
        /// It is updated only when TITLE is updated.
        /// Deprecated, use the mnemonic support directly in the TITLE attribute.
        pub fn setKey(self: *Initializer, arg: i32) Initializer {
            c.setIntAttribute(self.ref, "KEY", arg);
            return self.*;
        }

        pub fn setName(self: *Initializer, arg: [:0]const u8) Initializer {
            c.setStrAttribute(self.ref, "NAME", arg);
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
        /// HIGHLIGHT_CB HIGHLIGHT_CB Callback triggered every time the user selects an
        /// IupItem or IupSubmenu.
        /// Callback int function(Ihandle *ih); [in C] elem:highlight_cb() -> (ret:
        /// number) [in Lua] ih: identifier of the element that activated the event.
        /// Affects IupItem, IupSubmenu
        pub fn setHighlightCallback(self: *Initializer, callback: ?OnHighlightFn) Initializer {
            const Handler = CallbackHandler(Self, OnHighlightFn, "HIGHLIGHT_CB");
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
        c.setStrAttribute(self, attributeName, arg);
    }

    pub fn getStrAttribute(self: *Self, attributeName: [:0]const u8) [:0]const u8 {
        return c.getStrAttribute(self, attributeName);
    }

    pub fn setIntAttribute(self: *Self, attributeName: [:0]const u8, arg: i32) void {
        c.setIntAttribute(self, attributeName, arg);
    }

    pub fn getIntAttribute(self: *Self, attributeName: [:0]const u8) i32 {
        return c.getIntAttribute(self, attributeName);
    }

    pub fn setBoolAttribute(self: *Self, attributeName: [:0]const u8, arg: bool) void {
        c.setBoolAttribute(self, attributeName, arg);
    }

    pub fn getBoolAttribute(self: *Self, attributeName: [:0]const u8) bool {
        return c.getBoolAttribute(self, attributeName);
    }

    pub fn getPtrAttribute(handle: *Self, comptime T: type, attribute: [:0]const u8) ?*T {
        return c.getPtrAttribute(T, handle, attribute);
    }

    pub fn setPtrAttribute(handle: *Self, comptime T: type, attribute: [:0]const u8, value: ?*T) void {
        c.setPtrAttribute(T, handle, attribute, value);
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


    /// 
    /// ACTIVE, THEME: also accepted.
    pub fn getActive(self: *Self) bool {
        return c.getBoolAttribute(self, "ACTIVE");
    }


    /// 
    /// ACTIVE, THEME: also accepted.
    pub fn setActive(self: *Self, arg: bool) void {
        c.setBoolAttribute(self, "ACTIVE", arg);
    }


    /// 
    /// TITLE (non inheritable): Submenu Text.
    /// The "&" character can be used to define a mnemonic, the next character will
    /// be used as key.
    /// Use "&&" to show the "&" character instead on defining a mnemonic.
    pub fn getTitle(self: *Self) [:0]const u8 {
        return c.getStrAttribute(self, "TITLE");
    }


    /// 
    /// TITLE (non inheritable): Submenu Text.
    /// The "&" character can be used to define a mnemonic, the next character will
    /// be used as key.
    /// Use "&&" to show the "&" character instead on defining a mnemonic.
    pub fn setTitle(self: *Self, arg: [:0]const u8) void {
        c.setStrAttribute(self, "TITLE", arg);
    }


    /// 
    /// IMAGE [Windows and GTK Only] (non inheritable): Image name of the submenu image.
    /// In Windows, an item in a menu bar cannot have a check mark.
    /// Ignored if submenu in a menu bar.
    /// A recommended size would be 16x16 to fit the image in the menu item.
    /// In Windows, if larger than the check mark area it will be cropped.
    /// (since 3.0)
    pub fn getImage(self: *Self) [:0]const u8 {
        return c.getStrAttribute(self, "IMAGE");
    }


    /// 
    /// IMAGE [Windows and GTK Only] (non inheritable): Image name of the submenu image.
    /// In Windows, an item in a menu bar cannot have a check mark.
    /// Ignored if submenu in a menu bar.
    /// A recommended size would be 16x16 to fit the image in the menu item.
    /// In Windows, if larger than the check mark area it will be cropped.
    /// (since 3.0)
    pub fn setImage(self: *Self, arg: [:0]const u8) void {
        c.setStrAttribute(self, "IMAGE", arg);
    }

    pub fn getHandleName(self: *Self) [:0]const u8 {
        return c.getStrAttribute(self, "HANDLENAME");
    }

    pub fn setHandleName(self: *Self, arg: [:0]const u8) void {
        c.setStrAttribute(self, "HANDLENAME", arg);
    }

    pub fn getBgColor(self: *Self) ?iup.Rgb {
        return c.getRgb(self, "BGCOLOR");
    }

    pub fn setBgColor(self: *Self, rgb: iup.Rgb) void {
        c.setRgb(self, "BGCOLOR", rgb);
    }


    /// 
    /// KEY (non inheritable): Underlines a key character in the submenu title.
    /// It is updated only when TITLE is updated.
    /// Deprecated, use the mnemonic support directly in the TITLE attribute.
    pub fn getKey(self: *Self) i32 {
        return c.getIntAttribute(self, "KEY");
    }


    /// 
    /// KEY (non inheritable): Underlines a key character in the submenu title.
    /// It is updated only when TITLE is updated.
    /// Deprecated, use the mnemonic support directly in the TITLE attribute.
    pub fn setKey(self: *Self, arg: i32) void {
        c.setIntAttribute(self, "KEY", arg);
    }

    pub fn getName(self: *Self) [:0]const u8 {
        return c.getStrAttribute(self, "NAME");
    }

    pub fn setName(self: *Self, arg: [:0]const u8) void {
        c.setStrAttribute(self, "NAME", arg);
    }


    /// 
    /// WID (non inheritable): In Windows, returns the HMENU of the parent menu and
    /// it is actually created only when its child menu is mapped.
    pub fn getWId(self: *Self) i32 {
        return c.getIntAttribute(self, "WID");
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
    /// HIGHLIGHT_CB HIGHLIGHT_CB Callback triggered every time the user selects an
    /// IupItem or IupSubmenu.
    /// Callback int function(Ihandle *ih); [in C] elem:highlight_cb() -> (ret:
    /// number) [in Lua] ih: identifier of the element that activated the event.
    /// Affects IupItem, IupSubmenu
    pub fn setHighlightCallback(self: *Self, callback: ?OnHighlightFn) void {
        const Handler = CallbackHandler(Self, OnHighlightFn, "HIGHLIGHT_CB");
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

test "SubMenu Active" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.SubMenu.init().setActive(true).unwrap());
    defer item.deinit();

    var ret = item.getActive();

    try std.testing.expect(ret == true);
}

test "SubMenu Title" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.SubMenu.init().setTitle("Hello").unwrap());
    defer item.deinit();

    var ret = item.getTitle();

    try std.testing.expect(std.mem.eql(u8, ret, "Hello"));
}

test "SubMenu Image" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.SubMenu.init().setImage("Hello").unwrap());
    defer item.deinit();

    var ret = item.getImage();

    try std.testing.expect(std.mem.eql(u8, ret, "Hello"));
}

test "SubMenu HandleName" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.SubMenu.init().setHandleName("Hello").unwrap());
    defer item.deinit();

    var ret = item.getHandleName();

    try std.testing.expect(std.mem.eql(u8, ret, "Hello"));
}

test "SubMenu BgColor" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.SubMenu.init().setBgColor(.{ .r = 9, .g = 10, .b = 11 }).unwrap());
    defer item.deinit();

    var ret = item.getBgColor();

    try std.testing.expect(ret != null and ret.?.r == 9 and ret.?.g == 10 and ret.?.b == 11);
}

test "SubMenu Key" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.SubMenu.init().setKey(42).unwrap());
    defer item.deinit();

    var ret = item.getKey();

    try std.testing.expect(ret == 42);
}

test "SubMenu Name" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var item = try (iup.SubMenu.init().setName("Hello").unwrap());
    defer item.deinit();

    var ret = item.getName();

    try std.testing.expect(std.mem.eql(u8, ret, "Hello"));
}
