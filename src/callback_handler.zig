const std = @import("std");
const iup = @import("iup.zig");
const interop = @import("interop.zig");

const Element = iup.Element;
const Handle = iup.Handle;

///
/// Translates the C-API IUP's signature to zig function
pub fn CallbackHandler(comptime T: type, comptime TCallback: type, comptime action: [:0]const u8) type {
    return struct {

        /// Attribute key to store a reference to the zig callback on IUP's side
        const STORE = "__" ++ action;
        const ACTION = action;

        const Self = @This();

        /// Set or remove the callback function
        pub fn setCallback(handle: *T, callback: ?TCallback) void {
            if (callback) |ptr| {
                var nativeCallback = getNativeCallback(TCallback);
                interop.setNativeCallback(handle, ACTION, nativeCallback);
                interop.setCallbackStoreAttribute(TCallback, handle, STORE, ptr);
            } else {
                interop.setNativeCallback(handle, ACTION, null);
                interop.setCallbackStoreAttribute(TCallback, handle, STORE, null);
            }
        }

        ///
        /// Invoke the attached function
        /// args must be a tuple matching the TCallbackFn signature
        fn invoke(handle: ?*Handle, args: anytype) c_int {
            var validHandle = handle orelse @panic("Invalid handle from callback");

            if (getCallback(validHandle)) |callback| {
                var element = @ptrCast(*T, validHandle);
                @call(.{}, callback, .{element} ++ args) catch |err| switch (err) {
                    iup.CallbackResult.Ignore => return interop.consts.IUP_IGNORE,
                    iup.CallbackResult.Continue => return interop.consts.IUP_CONTINUE,
                    iup.CallbackResult.Close => return interop.consts.IUP_CLOSE,
                    else => return iup.MainLoop.onError(Element.fromRef(element), err),
                };
            }

            return interop.consts.IUP_DEFAULT;
        }

        /// Gets a zig function related on the IUP's handle
        fn getCallback(handle: *Handle) ?TCallback {
            return interop.getCallbackStoreAttribute(TCallback, handle, STORE);
        }

        /// Gets a native function with the propper signature
        fn getNativeCallback(comptime Function: type) interop.NativeCallbackFn {
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
                } else if (args.len == 3 and args[1] == i32 and args[2] == [:0]const u8) {
                    break :blk Self.nativeCallbackIFnis;
                } else if (args.len == 4 and args[1] == i32 and args[2] == i32 and args[3] == i32) {
                    break :blk Self.nativeCallbackIFniii;
                } else if (args.len == 4 and args[1] == [:0]const u8 and args[2] == i32 and args[3] == i32) {
                    break :blk Self.nativeCallbackIFnsii;
                } else if (args.len == 5 and args[1] == i32 and args[2] == i32 and args[3] == i32 and args[4] == i32) {
                    break :blk Self.nativeCallbackIFniiii;
                } else if (args.len == 5 and args[1] == i32 and args[2] == i32 and args[3] == i32 and args[4] == [:0]const u8) {
                    break :blk Self.nativeCallbackIFniiis;
                } else if (args.len == 6 and args[1] == i32 and args[2] == i32 and args[3] == i32 and args[4] == i32 and args[5] == [:0]const u8) {
                    break :blk Self.nativeCallbackIFniiiis;
                } else {
                    @compileLog("args = ", args);
                    unreachable;
                }
            };

            return @ptrCast(interop.NativeCallbackFn, native_callback);
        }

        // TODO: Add all supported callbacks
        // See iupcbs.h for more details

        fn nativeCallbackIFn(handle: ?*Handle) callconv(.C) c_int {
            return invoke(handle, .{});
        }

        fn nativeCallbackIFni(handle: ?*Handle, arg0: i32) callconv(.C) c_int {
            return invoke(handle, .{arg0});
        }

        fn nativeCallbackIFns(handle: ?*Handle, arg0: [*]const u8) callconv(.C) c_int {
            return invoke(handle, .{interop.fromCStr(arg0)});
        }

        fn nativeCallbackIFnii(handle: ?*Handle, arg0: i32, arg1: i32) callconv(.C) c_int {
            return invoke(handle, .{ arg0, arg1 });
        }

        fn nativeCallbackIFnis(handle: ?*Handle, arg0: i32, arg1: [*]const u8) callconv(.C) c_int {
            return invoke(handle, .{ arg0, interop.fromCStr(arg1) });
        }

        fn nativeCallbackIFniii(handle: ?*Handle, arg0: i32, arg1: i32, arg2: i32) callconv(.C) c_int {
            return invoke(handle, .{ arg0, arg1, arg2 });
        }

        fn nativeCallbackIFniiii(handle: ?*Handle, arg0: i32, arg1: i32, arg2: i32, arg3: i32) callconv(.C) c_int {
            return invoke(handle, .{ arg0, arg1, arg2, arg3 });
        }

        fn nativeCallbackIFnsii(handle: ?*Handle, arg0: [*]const u8, arg1: i32, arg2: i32) callconv(.C) c_int {
            return invoke(handle, .{ interop.fromCStr(arg0), arg1, arg2 });
        }

        fn nativeCallbackIFniiis(handle: ?*Handle, arg0: i32, arg1: i32, arg2: i32, arg3: [*]const u8) callconv(.C) c_int {
            return invoke(handle, .{ arg0, arg1, arg2, interop.fromCStr(arg3) });
        }

        fn nativeCallbackIFniiiis(handle: ?*Handle, arg0: i32, arg1: i32, arg2: i32, arg3: i32, arg4: [*]const u8) callconv(.C) c_int {
            return invoke(handle, .{ arg0, arg1, arg2, arg3, interop.fromCStr(arg4) });
        }
    };
}
