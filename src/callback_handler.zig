const std = @import("std");
const iup = @import("iup.zig");
const c = @import("c.zig");

const Element = iup.Element;

///
/// Translates the C-API IUP's signature to zig function
pub fn CallbackHandler(comptime T: type, comptime TCallback: type, comptime action: [:0]const u8) type {
    return struct {

        /// Attribute key to store a reference to the zig callback on IUP's side
        const STORE = comptime c.toCStr("__" ++ action);
        const ACTION = comptime c.toCStr(action);

        const Self = @This();

        /// Set or remove the callback function
        pub fn setCallback(handle: *T, callback: ?TCallback) void {
            if (callback) |ptr| {
                _ = c.IupSetCallback(c.getHandle(handle), ACTION, getNativeCallback(TCallback));
                c.IupSetAttribute(c.getHandle(handle), STORE, @ptrCast([*c]const u8, ptr));
            } else {
                _ = c.IupSetCallback(c.getHandle(handle), ACTION, null);
                c.IupSetAttribute(c.getHandle(handle), STORE, null);
            }
        }

        ///
        /// Invoke the attached function
        /// args must be a tuple matching the TCallbackFn signature
        fn invoke(handle: ?*c.Ihandle, args: anytype) c_int {
            var validHandle = handle orelse @panic("Invalid handle from callback");

            if (getCallback(validHandle)) |callback| {
                var element = @ptrCast(*T, validHandle);
                @call(.{}, callback, .{element} ++ args) catch |err| {
                    iup.MainLoop.onError(Element.fromRef(element), err);
                };
            }

            return c.IUP_DEFAULT;
        }

        /// Gets a zig function related on the IUP's handle
        fn getCallback(handle: *c.Ihandle) ?TCallback {
            var ptr = c.IupGetAttribute(handle, STORE);
            if (ptr == null) {
                return null;
            } else {
                return @ptrCast(TCallback, ptr);
            }
        }

        /// Gets a native function with the propper signature
        fn getNativeCallback(comptime Function: type) c.Icallback {
            const native_callback = comptime blk: {
                const info = @typeInfo(Function);
                if (info != .Fn)
                    @compileError("getNativeCallback expects a function type");

                const function_info = info.Fn;
                var args: [function_info.args.len]type = undefined;
                inline for (function_info.args) |arg, i| {
                    args[i] = arg.arg_type.?;
                }

                // TODO: Add all supported callbacks
                // See iupcbs.h for more details

                if (args.len == 1) {
                    break :blk Self.nativeCallbackIFn;
                } else if (args.len == 2 and args[1] == i32) {
                    break :blk Self.nativeCallbackIFni;
                } else if (args.len == 2 and args[1] == [:0]const u8) {
                    break :blk Self.nativeCallbackIFns;
                } else if (args.len == 3 and args[1] == i32 and args[2] == i32) {
                    break :blk Self.nativeCallbackIFnii;
                } else if (args.len == 4 and args[1] == i32 and args[2] == i32 and args[3] == i32) {
                    break :blk Self.nativeCallbackIFniii;
                } else if (args.len == 4 and args[1] == [:0]const u8 and args[2] == i32 and args[3] == i32) {
                    break :blk Self.nativeCallbackIFnsii;
                } else {
                    unreachable;
                }
            };

            return @ptrCast(c.Icallback, native_callback);
        }

        // TODO: Add all supported callbacks
        // See iupcbs.h for more details

        fn nativeCallbackIFn(handle: ?*c.Ihandle) callconv(.C) c_int {
            return invoke(handle, .{});
        }

        fn nativeCallbackIFni(handle: ?*c.Ihandle, arg0: i32) callconv(.C) c_int {
            return invoke(handle, .{arg0});
        }

        fn nativeCallbackIFns(handle: ?*c.Ihandle, arg0: [*]const u8) callconv(.C) c_int {
            return invoke(handle, .{ c.fromCStr(arg0) });
        }

        fn nativeCallbackIFnii(handle: ?*c.Ihandle, arg0: i32, arg1: i32) callconv(.C) c_int {
            return invoke(handle, .{ arg0, arg1 });
        }

        fn nativeCallbackIFniii(handle: ?*c.Ihandle, arg0: i32, arg1: i32, arg2: i32) callconv(.C) c_int {
            return invoke(handle, .{ arg0, arg1, arg2 });
        }

        fn nativeCallbackIFnsii(handle: ?*c.Ihandle, arg0: [*]const u8, arg1: i32, arg2: i32) callconv(.C) c_int {
            return invoke(handle, .{ c.fromCStr(arg0), arg1, arg2});
        }
    };
}
