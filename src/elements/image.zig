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
/// Creates an image to be shown on a label, button, toggle, or as a cursor.
/// (IupImageRGB and IupImageRGBA, since 3.0)
pub const Image = opaque {
    pub const CLASS_NAME = "image";
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


        /// 
        /// RESIZE (write-only): given a new size if format "widthxheight", changes
        /// WIDTH and HEIGHT attributes, and resizes the image contents using bilinear
        /// interpolation for RGB and RGBA images and nearest neighborhood for 8 bits.
        /// (since 3.24)
        pub fn setResize(self: *Initializer, width: ?i32, height: ?i32) Initializer {
            var buffer: [128]u8 = undefined;
            var value = Size.intIntToString(&buffer, width, height);
            c.setStrAttribute(self.ref, "RESIZE", value);
            return self.*;
        }


        /// 
        /// RESHAPE (write-only): given a new size if format "widthxheight", allocates
        /// enough memory for the new size and changes WIDTH and HEIGHT attributes.
        /// Image contents is ignored and it will contain trash after the reshape.
        /// (since 3.24)
        pub fn setReshape(self: *Initializer, width: ?i32, height: ?i32) Initializer {
            var buffer: [128]u8 = undefined;
            var value = Size.intIntToString(&buffer, width, height);
            c.setStrAttribute(self.ref, "RESHAPE", value);
            return self.*;
        }


        /// 
        /// AUTOSCALE: automatically scale the image by a given real factor.
        /// Can be "DPI" or a scale factor.
        /// If not defined the global attribute IMAGEAUTOSCALE will be used.
        /// Values are the same of the global attribute.
        /// The minimum resulted size when automatically resized is 24 pixels height
        /// (since 3.29).
        /// (since 3.16)
        pub fn setAutoScale(self: *Initializer, arg: bool) Initializer {
            c.setBoolAttribute(self.ref, "AUTOSCALE", arg);
            return self.*;
        }

        pub fn setHandleName(self: *Initializer, arg: [:0]const u8) Initializer {
            c.setStrAttribute(self.ref, "HANDLENAME", arg);
            return self.*;
        }


        /// 
        /// CLEARCACHE (write-only): clears the internal native image cache, so WID can
        /// be dynamically changed.
        /// (since 3.24)
        pub fn clearCache(self: *Initializer) Initializer {
            c.setStrAttribute(self.ref, "CLEARCACHE", null);
            return self.*;
        }


        /// 
        /// BGCOLOR: The color used for transparency.
        /// If not defined uses the BGCOLOR of the control that contains the image.
        /// In Motif, the alpha channel in RGBA images is always composed with the
        /// control BGCOLOR by IUP prior to setting the image at the control.
        /// In Windows and in GTK, the alpha channel is composed internally by the system.
        /// But in Windows for some controls the alpha must be composed a priori also,
        /// it includes: IupItem and IupSubmenu always; and IupToggle when NOT using
        /// Visual Styles.
        /// This implies that if the control background is not uniform then probably
        /// there will be a visible difference where it should be transparent.
        pub fn setBgColor(self: *Initializer, rgb: iup.Rgb) Initializer {
            c.setRgb(self.ref, "BGCOLOR", rgb);
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
    /// RESIZE (write-only): given a new size if format "widthxheight", changes
    /// WIDTH and HEIGHT attributes, and resizes the image contents using bilinear
    /// interpolation for RGB and RGBA images and nearest neighborhood for 8 bits.
    /// (since 3.24)
    pub fn setResize(self: *Self, width: ?i32, height: ?i32) void {
        var buffer: [128]u8 = undefined;
        var value = Size.intIntToString(&buffer, width, height);
        c.setStrAttribute(self, "RESIZE", value);
    }


    /// 
    /// SCALED (read-only): returns Yes if the image has been resized.
    /// (since 3.25)
    pub fn getScaled(self: *Self) bool {
        return c.getBoolAttribute(self, "SCALED");
    }


    /// 
    /// BPP (read-only): returns the number of bits per pixel in the image.
    /// Images created with IupImage returns 8, with IupImageRGB returns 24 and
    /// with IupImageRGBA returns 32.
    /// (since 3.0)
    pub fn getBpp(self: *Self) i32 {
        return c.getIntAttribute(self, "BPP");
    }


    /// 
    /// RESHAPE (write-only): given a new size if format "widthxheight", allocates
    /// enough memory for the new size and changes WIDTH and HEIGHT attributes.
    /// Image contents is ignored and it will contain trash after the reshape.
    /// (since 3.24)
    pub fn setReshape(self: *Self, width: ?i32, height: ?i32) void {
        var buffer: [128]u8 = undefined;
        var value = Size.intIntToString(&buffer, width, height);
        c.setStrAttribute(self, "RESHAPE", value);
    }


    /// 
    /// CHANNELS (read-only): returns the number of channels in the image.
    /// Images created with IupImage returns 1, with IupImageRGB returns 3 and with
    /// IupImageRGBA returns 4.
    /// (since 3.0)
    pub fn getChannels(self: *Self) i32 {
        return c.getIntAttribute(self, "CHANNELS");
    }


    /// 
    /// AUTOSCALE: automatically scale the image by a given real factor.
    /// Can be "DPI" or a scale factor.
    /// If not defined the global attribute IMAGEAUTOSCALE will be used.
    /// Values are the same of the global attribute.
    /// The minimum resulted size when automatically resized is 24 pixels height
    /// (since 3.29).
    /// (since 3.16)
    pub fn getAutoScale(self: *Self) bool {
        return c.getBoolAttribute(self, "AUTOSCALE");
    }


    /// 
    /// AUTOSCALE: automatically scale the image by a given real factor.
    /// Can be "DPI" or a scale factor.
    /// If not defined the global attribute IMAGEAUTOSCALE will be used.
    /// Values are the same of the global attribute.
    /// The minimum resulted size when automatically resized is 24 pixels height
    /// (since 3.29).
    /// (since 3.16)
    pub fn setAutoScale(self: *Self, arg: bool) void {
        c.setBoolAttribute(self, "AUTOSCALE", arg);
    }

    pub fn getHandleName(self: *Self) [:0]const u8 {
        return c.getStrAttribute(self, "HANDLENAME");
    }

    pub fn setHandleName(self: *Self, arg: [:0]const u8) void {
        c.setStrAttribute(self, "HANDLENAME", arg);
    }


    /// 
    /// HEIGHT (read-only): Image height in pixels.
    pub fn getHeight(self: *Self) i32 {
        return c.getIntAttribute(self, "HEIGHT");
    }


    /// 
    /// CLEARCACHE (write-only): clears the internal native image cache, so WID can
    /// be dynamically changed.
    /// (since 3.24)
    pub fn clearCache(self: *Self) void {
        c.setStrAttribute(self, "CLEARCACHE", null);
    }


    /// 
    /// BGCOLOR: The color used for transparency.
    /// If not defined uses the BGCOLOR of the control that contains the image.
    /// In Motif, the alpha channel in RGBA images is always composed with the
    /// control BGCOLOR by IUP prior to setting the image at the control.
    /// In Windows and in GTK, the alpha channel is composed internally by the system.
    /// But in Windows for some controls the alpha must be composed a priori also,
    /// it includes: IupItem and IupSubmenu always; and IupToggle when NOT using
    /// Visual Styles.
    /// This implies that if the control background is not uniform then probably
    /// there will be a visible difference where it should be transparent.
    pub fn getBgColor(self: *Self) ?iup.Rgb {
        return c.getRgb(self, "BGCOLOR");
    }


    /// 
    /// BGCOLOR: The color used for transparency.
    /// If not defined uses the BGCOLOR of the control that contains the image.
    /// In Motif, the alpha channel in RGBA images is always composed with the
    /// control BGCOLOR by IUP prior to setting the image at the control.
    /// In Windows and in GTK, the alpha channel is composed internally by the system.
    /// But in Windows for some controls the alpha must be composed a priori also,
    /// it includes: IupItem and IupSubmenu always; and IupToggle when NOT using
    /// Visual Styles.
    /// This implies that if the control background is not uniform then probably
    /// there will be a visible difference where it should be transparent.
    pub fn setBgColor(self: *Self, rgb: iup.Rgb) void {
        c.setRgb(self, "BGCOLOR", rgb);
    }


    /// 
    /// ORIGINALSCALE (read-only): returns the width and height before the image
    /// was scaled.
    /// (since 3.25)
    pub fn getOriginalScale(self: *Self) Size {
        var str = c.getStrAttribute(self, "ORIGINALSCALE");
        return Size.parse(str);
    }


    /// 
    /// WIDTH (read-only): Image width in pixels.
    pub fn getWidth(self: *Self) i32 {
        return c.getIntAttribute(self, "WIDTH");
    }


    /// 
    /// RASTERSIZE (read-only): returns the image size in pixels.
    /// (since 3.0)
    pub fn getRasterSize(self: *Self) Size {
        var str = c.getStrAttribute(self, "RASTERSIZE");
        return Size.parse(str);
    }


    /// 
    /// WID (read-only): returns the internal pixels data pointer.
    /// (since 3.0).
    /// If the image was created in C then there is no way to access its pixels
    /// values in Lua, except as an userdata using the WID attribute.
    pub fn getWId(self: *Self) i32 {
        return c.getIntAttribute(self, "WID");
    }
};
