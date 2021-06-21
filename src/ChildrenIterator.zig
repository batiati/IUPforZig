const std = @import("std");
const c = @import("c.zig");
const iup = @import("iup.zig");

const Element = iup.Element;
const Self = @This();

handle: *c.Ihandle,
len: c_int,
index: c_int,

pub const NoChildren = Self{ .handle = undefined, .len = 0, .index = 0 };

pub fn init(handle: anytype) Self {
    return .{ .handle = c.getHandle(handle), .len = c.IupGetChildCount(c.getHandle(handle)), .index = 0 };
}

pub fn next(self: *Self) ?Element {
    if (self.index >= self.len) return null;

    var child = c.IupGetChild(self.handle, self.index) orelse return null;
    var className = c.fromCStr(c.IupGetClassName(child));

    self.index += 1;

    return Element.fromClassName(className, child);
}

pub fn reset(self: *Self) void {
    self.index = 0;
}
