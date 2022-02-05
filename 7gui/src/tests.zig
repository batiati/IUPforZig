const std = @import("std");
test {
    _ = std.testing.refAllDecls(@import("counter.zig"));
    _ = std.testing.refAllDecls(@import("temp_conv.zig"));
    _ = std.testing.refAllDecls(@import("book_flight.zig"));
    _ = std.testing.refAllDecls(@import("timer.zig"));
    _ = std.testing.refAllDecls(@import("crud.zig"));
    _ = std.testing.refAllDecls(@import("circle.zig"));
    _ = std.testing.refAllDecls(@import("cells.zig"));
}
