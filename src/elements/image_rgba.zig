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

pub const ImageRgba = opaque {
    pub const CLASS_NAME = "imagergba";
    const Self = @This();

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

        pub fn resize(self: *Initializer, width: ?i32, height: ?i32) Initializer {
            var buffer: [128]u8 = undefined;
            var value = Size.intIntToString(&buffer, width, height);
            c.setStrAttribute(self.ref, "RESIZE", .{}, value);
            return self.*;
        }

        pub fn reshape(self: *Initializer, width: ?i32, height: ?i32) Initializer {
            var buffer: [128]u8 = undefined;
            var value = Size.intIntToString(&buffer, width, height);
            c.setStrAttribute(self.ref, "RESHAPE", .{}, value);
            return self.*;
        }

        pub fn setAutoScale(self: *Initializer, arg: bool) Initializer {
            c.setBoolAttribute(self.ref, "AUTOSCALE", .{}, arg);
            return self.*;
        }

        pub fn setHandleName(self: *Initializer, arg: [:0]const u8) Initializer {
            c.setHandle(self.ref, arg);
            return self.*;
        }

        pub fn clearCache(self: *Initializer) Initializer {
            c.setStrAttribute(self.ref, "CLEARCACHE", .{}, null);
            return self.*;
        }

        pub fn setBgColor(self: *Initializer, rgb: iup.Rgb) Initializer {
            c.setRgb(self.ref, "BGCOLOR", .{}, rgb);
            return self.*;
        }
    };

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
    /// Creates an image to be shown on a label, button, toggle, or as a cursor.
    /// width: Image width in pixels.
    /// height: Image height in pixels.
    /// pixels: Vector containing the value of each pixel. 
    /// IupImage uses 1 value per pixel, IupImageRGB uses 3 values and  IupImageRGBA uses 4 values per pixel.
    /// Each value is always 8 bit.
    /// Origin is at the top-left corner and data is oriented top to bottom, and left to right.
    /// The pixels array is duplicated internally so you can discard it after the call.
    pub fn init(width: i32, height: i32, imgdata: ?[]const u8) Initializer {
        var handle = c.create_image(Self, width, height, imgdata);

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
        c.destroy(self);
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

    pub fn resize(self: *Self, width: ?i32, height: ?i32) void {
        var buffer: [128]u8 = undefined;
        var value = Size.intIntToString(&buffer, width, height);
        c.setStrAttribute(self, "RESIZE", .{}, value);
    }

    pub fn getScaled(self: *Self) bool {
        return c.getBoolAttribute(self, "SCALED", .{});
    }

    pub fn getBpp(self: *Self) i32 {
        return c.getIntAttribute(self, "BPP", .{});
    }

    pub fn reshape(self: *Self, width: ?i32, height: ?i32) void {
        var buffer: [128]u8 = undefined;
        var value = Size.intIntToString(&buffer, width, height);
        c.setStrAttribute(self, "RESHAPE", .{}, value);
    }

    pub fn getChannels(self: *Self) i32 {
        return c.getIntAttribute(self, "CHANNELS", .{});
    }

    pub fn getAutoScale(self: *Self) bool {
        return c.getBoolAttribute(self, "AUTOSCALE", .{});
    }

    pub fn setAutoScale(self: *Self, arg: bool) void {
        c.setBoolAttribute(self, "AUTOSCALE", .{}, arg);
    }

    pub fn getHandleName(self: *Self) [:0]const u8 {
        return c.getStrAttribute(self, "HANDLENAME", .{});
    }

    pub fn setHandleName(self: *Self, arg: [:0]const u8) void {
        c.setHandle(self, arg);
    }

    pub fn getHeight(self: *Self) i32 {
        return c.getIntAttribute(self, "HEIGHT", .{});
    }

    pub fn clearCache(self: *Self) void {
        c.setStrAttribute(self, "CLEARCACHE", .{}, null);
    }

    pub fn getBgColor(self: *Self) ?iup.Rgb {
        return c.getRgb(self, "BGCOLOR", .{});
    }

    pub fn setBgColor(self: *Self, rgb: iup.Rgb) void {
        c.setRgb(self, "BGCOLOR", .{}, rgb);
    }

    pub fn getOriginalScale(self: *Self) Size {
        var str = c.getStrAttribute(self, "ORIGINALSCALE", .{});
        return Size.parse(str);
    }

    pub fn getWidth(self: *Self) i32 {
        return c.getIntAttribute(self, "WIDTH", .{});
    }

    pub fn getRasterSize(self: *Self) Size {
        var str = c.getStrAttribute(self, "RASTERSIZE", .{});
        return Size.parse(str);
    }

    pub fn getWId(self: *Self) i32 {
        return c.getIntAttribute(self, "WID", .{});
    }
};
