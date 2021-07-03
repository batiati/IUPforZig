const std = @import("std");
const interop = @import("interop.zig");
const iup = @import("iup.zig");

const Element = iup.Element;
const Self = @This();

handle: *iup.Handle,
len: c_int,
index: c_int,

pub const NoChildren = Self{ .handle = undefined, .len = 0, .index = 0 };

pub fn init(handle: anytype) Self {
    return .{ .handle = interop.getHandle(handle), .len = interop.getChildCount(handle), .index = 0 };
}

pub fn next(self: *Self) ?Element {
    if (self.index >= self.len) return null;

    var child = interop.getChild(self.handle, self.index) orelse return null;
    var className = interop.getClassName(child);

    self.index += 1;

    return Element.fromClassName(className, child);
}

pub fn reset(self: *Self) void {
    self.index = 0;
}
