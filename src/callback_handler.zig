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
        pub fn setCallback(handle: *T, callback: ?*const TCallback) void {
            if (callback) |ptr| {
                var nativeCallback = getNativeCallback(TCallback);
                interop.setNativeCallback(handle, ACTION, nativeCallback);
                interop.setCallbackStoreAttribute(TCallback, handle, STORE, ptr);
            } else {
                interop.setNativeCallback(handle, ACTION, null);
                interop.setCallbackStoreAttribute(TCallback, handle, STORE, null);
            }
        }

        pub fn setGlobalCallback(callback: ?*const TCallback) void {
            if (callback) |ptr| {
                var nativeCallback = getNativeCallback(TCallback);
                interop.setNativeCallback({}, ACTION, nativeCallback);
                interop.setCallbackStoreAttribute(TCallback, {}, STORE, ptr);
            } else {
                interop.setNativeCallback({}, ACTION, null);
                interop.setCallbackStoreAttribute(TCallback, {}, STORE, null);
            }
        }

        ///
        /// Invoke the attached function, converting zig erros to c_int return convention.
        /// args must be a tuple matching the TCallbackFn signature
        fn invoke(handle: ?*Handle, args: anytype) c_int {
            if (T == void) {
                if (getGlobalCallback()) |callback| {
                    @call(.auto, callback, args) catch |err| switch (err) {
                        iup.CallbackResult.Ignore => return interop.consts.IUP_IGNORE,
                        iup.CallbackResult.Continue => return interop.consts.IUP_CONTINUE,
                        iup.CallbackResult.Close => return interop.consts.IUP_CLOSE,
                        else => return iup.MainLoop.onError(null, err),
                    };
                }
            } else {
                var validHandle = handle orelse @panic("Invalid handle from callback");

                if (getCallback(validHandle)) |callback| {
                    var element: *T = @ptrCast(validHandle);
                    @call(.auto, callback, .{element} ++ args) catch |err| switch (err) {
                        iup.CallbackResult.Ignore => return interop.consts.IUP_IGNORE,
                        iup.CallbackResult.Continue => return interop.consts.IUP_CONTINUE,
                        iup.CallbackResult.Close => return interop.consts.IUP_CLOSE,
                        else => return iup.MainLoop.onError(Element.fromRef(element), err),
                    };
                }
            }

            return interop.consts.IUP_DEFAULT;
        }

        ///
        /// Invoke the attached function, returns the value, errors are not supported
        /// args must be a tuple matching the TCallbackFn signature
        fn invokeWithReturn(comptime TReturn: type, handle: ?*Handle, args: anytype) ?TReturn {
            if (T == void) {
                if (getGlobalCallback()) |callback| {
                    return @call(.auto, callback, args);
                }
            } else {
                var validHandle = handle orelse @panic("Invalid handle from callback");

                if (getCallback(validHandle)) |callback| {
                    var element: *T = @ptrCast(validHandle);
                    return @call(.auto, callback, .{element} ++ args);
                }
            }

            return null;
        }

        /// Gets a zig function related on the IUP's handle
        fn getCallback(handle: *Handle) ?*const TCallback {
            return interop.getCallbackStoreAttribute(TCallback, handle, STORE);
        }

        /// Gets a zig function related on the IUP's global handle
        fn getGlobalCallback() ?*const TCallback {
            return interop.getCallbackStoreAttribute(TCallback, {}, STORE);
        }

        /// Gets a native function with the propper signature
        fn getNativeCallback(comptime Function: type) interop.NativeCallbackFn {
            const native_callback = comptime blk: {
                const info = @typeInfo(Function);
                if (info != .Fn)
                    @compileError("getNativeCallback expects a function type");

                const function_info: std.builtin.Type.Fn = info.Fn;
                const return_type = function_info.return_type orelse void;

                var params: [function_info.params.len]type = undefined;
                inline for (function_info.params, 0..) |param, i| {
                    params[i] = param.type.?;
                }

                const S = [:0]const u8;
                const I = i32;
                const F = f32;
                const D = f64;
                const P = ?*anyopaque;

                // TODO: Add all supported callbacks
                // See iupcbs.h for more details

                if (return_type == S) {
                    if (params.len == 3 and params[1] == I and params[2] == I) {
                        break :blk Self.nativeCallbackIFnii_s;
                    }
                }

                if (params.len == 0) {
                    break :blk Self.nativeCallbackFn;
                } else if (params.len == 1) {
                    break :blk Self.nativeCallbackIFn;
                } else if (params.len == 2 and params[1] == I) {
                    break :blk Self.nativeCallbackIFni;
                } else if (params.len == 2 and params[1] == S) {
                    break :blk Self.nativeCallbackIFns;
                } else if (params.len == 3 and params[1] == I and params[2] == I) {
                    break :blk Self.nativeCallbackIFnii;
                } else if (params.len == 3 and params[1] == F and params[2] == F) {
                    break :blk Self.nativeCallbackIFnff;
                } else if (params.len == 3 and params[1] == I and params[2] == S) {
                    break :blk Self.nativeCallbackIFnis;
                } else if (params.len == 4 and params[1] == I and params[2] == I and params[3] == I) {
                    break :blk Self.nativeCallbackIFniii;
                } else if (params.len == 4 and params[1] == S and params[2] == I and params[3] == I) {
                    break :blk Self.nativeCallbackIFnsii;
                } else if (params.len == 4 and params[1] == I and params[2] == I and params[3] == S) {
                    break :blk Self.nativeCallbackIFniis;
                } else if (params.len == 5 and params[1] == I and params[2] == I and params[3] == I and params[4] == I) {
                    break :blk Self.nativeCallbackIFniiii;
                } else if (params.len == 5 and params[1] == S and params[2] == I and params[3] == D and params[4] == P) {
                    break :blk Self.nativeCallbackIFnsifp;
                } else if (params.len == 5 and params[1] == I and params[2] == I and params[3] == I and params[4] == I and params[5] == S) {
                    break :blk Self.nativeCallbackIFniiiis;
                } else if (params.len == 6 and params[1] == I and params[2] == I and params[3] == I and params[4] == I and params[5] == S) {
                    break :blk Self.nativeCallbackIFniiiis;
                } else {
                    @compileLog("params = ", params);
                    unreachable;
                }
            };

            return @as(interop.NativeCallbackFn, @ptrCast(&native_callback));
        }

        // TODO: Add all supported callbacks
        // See iupcbs.h for more details

        fn nativeCallbackFn() callconv(.C) c_int {
            return invoke(null, .{});
        }

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

        fn nativeCallbackIFnff(handle: ?*Handle, arg0: f32, arg1: f32) callconv(.C) c_int {
            return invoke(handle, .{ arg0, arg1 });
        }

        fn nativeCallbackIFniii(handle: ?*Handle, arg0: i32, arg1: i32, arg2: i32) callconv(.C) c_int {
            return invoke(handle, .{ arg0, arg1, arg2 });
        }

        fn nativeCallbackIFniis(handle: ?*Handle, arg0: i32, arg1: i32, arg2: [*c]const u8) callconv(.C) c_int {
            return invoke(handle, .{ arg0, arg1, interop.fromCStr(arg2) });
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

        fn nativeCallbackIFnsifp(handle: ?*Handle, arg0: [*]const u8, arg1: i32, arg2: f64, arg3: ?*anyopaque) callconv(.C) c_int {
            return invoke(handle, .{ interop.fromCStr(arg0), arg1, arg2, arg3 });
        }

        fn nativeCallbackIFnii_s(handle: ?*Handle, arg0: i32, arg1: i32) callconv(.C) [*c]const u8 {
            var str = invokeWithReturn([:0]const u8, handle, .{ arg0, arg1 });
            return interop.toCStr(str);
        }
    };
}
