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
/// Creates a thread element in IUP, which is not associated to any interface element.
/// It is a very simple support to create and manage threads in a multithread environment.
/// It inherits from IupUser.
/// In non Windows systems uses the pthreads library.
pub const Thread = opaque {
    pub const CLASS_NAME = "thread";
    const Self = @This();

    /// 
    /// THREAD_CB: Action generated when the thread is started.
    /// If this callback returns or does not exist the thread is terminated.
    /// int function(Ihandle* ih); [in C]ih:thread_cb() -> (ret: number) [in Lua]
    pub const OnThreadFn = fn (self: *Self) anyerror!void;

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
        /// START (write-only, non inheritable): starts the thread and calls the callback.
        /// Can be YES only.
        /// The thread exits when the callback is terminated.
        pub fn start(self: *Initializer, arg: bool) Initializer {
            c.setBoolAttribute(self.ref, "START", .{}, arg);
            return self.*;
        }

        /// 
        /// THREAD_CB: Action generated when the thread is started.
        /// If this callback returns or does not exist the thread is terminated.
        /// int function(Ihandle* ih); [in C]ih:thread_cb() -> (ret: number) [in Lua]
        pub fn setThreadCallback(self: *Initializer, callback: ?OnThreadFn) Initializer {
            const Handler = CallbackHandler(Self, OnThreadFn, "THREAD_CB");
            Handler.setCallback(self.ref, callback);
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
    /// Creates an interface element given its class name and parameters.
    /// After creation the element still needs to be attached to a container and mapped to the native system so it can be visible.
    pub fn init() Initializer {
        var handle = c.create(Self);

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


    /// 
    /// START (write-only, non inheritable): starts the thread and calls the callback.
    /// Can be YES only.
    /// The thread exits when the callback is terminated.
    pub fn start(self: *Self, arg: bool) void {
        c.setBoolAttribute(self, "START", .{}, arg);
    }

    /// 
    /// THREAD_CB: Action generated when the thread is started.
    /// If this callback returns or does not exist the thread is terminated.
    /// int function(Ihandle* ih); [in C]ih:thread_cb() -> (ret: number) [in Lua]
    pub fn setThreadCallback(self: *Self, callback: ?OnThreadFn) void {
        const Handler = CallbackHandler(Self, OnThreadFn, "THREAD_CB");
        Handler.setCallback(self, callback);
    }
};
