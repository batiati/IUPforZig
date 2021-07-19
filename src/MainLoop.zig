const std = @import("std");
const interop = @import("interop.zig");
const iup = @import("iup.zig");

///
/// Global handler for unhandled errors thrown inside callback functions
pub const ErrorHandlerFn = fn (Element, anyerror) anyerror!void;

const MainLoop = @This();
const Element = iup.Element;

var exit_error: ?anyerror = null;
var error_handler: ?ErrorHandlerFn = null;

///
/// Initializes the IUP toolkit. Must be called before any other IUP function.
pub fn open() iup.Error!void {
    try interop.open();
}

///
/// Sets a callback function to handle errors returned inside the main loop
/// Rethrow the error to terminate the application
pub fn setErrorHandler(value: ?ErrorHandlerFn) void {
    MainLoop.error_handler = value;
}

///
/// Terminates the current message loop. It has the same effect of a callback returning IUP_CLOSE.
pub fn exitLoop() void {
    interop.exitLoop();
}

///
/// Called by the message loop
pub fn onError(element: Element, err: anyerror) i32 {
    if (MainLoop.error_handler) |func| {
        if (func(element, err)) {
            return interop.consts.IUP_DEFAULT;
        } else |rethrown| {
            MainLoop.exit_error = rethrown;
        }
    }

    return interop.consts.IUP_CLOSE;
}

///
/// Executes the user interaction until a callback returns IUP_CLOSE, 
/// IupExitLoop is called, or hiding the last visible dialog.
/// When this function is called, it will interrupt the program execution until a callback returns IUP_CLOSE, 
/// IupExitLoop is called, or there are no visible dialogs.
/// If you cascade many calls to IupMainLoop there must be a "return IUP_CLOSE" or 
/// IupExitLoop call for each cascade level, hiddinh all dialogs will close only one level. 
/// Call IupMainLoopLevel to obtain the current level.
/// If IupMainLoop is called without any visible dialogs and no active timers, 
/// the application will hang and will not be possible to close the main loop. 
/// The process will have to be interrupted by the system.
/// When the last visible dialog is hidden the IupExitLoop function is automatically called, 
/// causing the IupMainLoop to return. To avoid that set LOCKLOOP=YES before hiding the last dialog.
pub fn beginLoop() !void {
    interop.beginLoop();
    if (exit_error) |err| return err;
}

///
/// Returns a string with the IUP version number.
pub fn showVersion() void {
    interop.showVersion();
}

///
/// Ends the IUP toolkit and releases internal memory.
/// It will also automatically destroy all dialogs and all elements that have names.
pub fn close() void {
    interop.close();
}
