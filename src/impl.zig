const std = @import("std");
const c = @import("c.zig");
const iup = @import("iup.zig");

const debug = std.debug;
const trait = std.meta.trait;

const Element = iup.Element;
const Dialog = iup.Dialog;
const Handle = iup.Handle;
const VBox = iup.VBox;
const Menu = iup.Menu;
const SubMenu = iup.SubMenu;
const Error = iup.Error;
const ChildrenIterator = iup.ChildrenIterator;

// TODO: Improves the organization in separated files
// Needs some use cases from other elements to define the better way to organize

pub fn Impl(comptime T: type) type {
    return struct {

        ///
        /// Updates the size and layout of all controls in the same dialog. 
        /// To be used after changing size attributes, or attributes that affect the size of the control. Can be used for any element inside a dialog, but the layout of the dialog and all controls will be updated. It can change the layout of all the controls inside the dialog because of the dynamic layout positioning.
        pub fn refresh(self: *T) !void {
            _ = c.IupRefresh(c.getHandle(self));
        }

        pub fn appendChildren(self: *T, tuple: anytype) !void {
            const typeOf = @TypeOf(tuple);

            if (comptime trait.isTuple(typeOf)) {
                const typeInfo = @typeInfo(typeOf).Struct;

                if (T == Dialog) {

                    // Dialogs can have just one child, and one Menu
                    // This sintax-sugar adds the top-level Menu along the children list

                    var children_qty: usize = 0;

                    inline for (typeInfo.fields) |field| {
                        var element = try getArgHandle(@field(tuple, field.name));

                        if (element == .Menu) {
                            self.setMenu(element.Menu);
                        } else if (element == .SubMenu) {
                            try appendDialogSubMenu(self, element.SubMenu);
                        } else {
                            children_qty += 1;
                        }
                    }

                    if (children_qty > 1)
                        return Error.InvalidChild;

                    inline for (typeInfo.fields) |field| {
                        var element = try getArgHandle(@field(tuple, field.name));

                        if (element != .Menu and element != .SubMenu) {
                            try appendChild(self, element);
                        }
                    }
                } else {

                    // Regular appendChild method for most containers
                    inline for (typeInfo.fields) |field| {
                        try appendChild(self, @field(tuple, field.name));
                    }
                }
            } else {
                try appendChild(self, tuple);
            }
        }

        pub fn appendChild(self: *T, child: anytype) !void {
            var element = try getArgHandle(child);

            if (T == Dialog) {
                if (element == .Menu) {
                    self.setMenu(element.Menu);
                } else if (element == .SubMenu) {
                    try appendDialogSubMenu(self, element.SubMenu);
                } else {
                    var parent_handle = if (self.children().next()) |container| container.getHandle() else c.getHandle(self);
                    var ret = c.IupAppend(parent_handle, element.getHandle());
                    if (ret == null) {
                        return Error.InvalidChild;
                    }
                }
            } else if (T == SubMenu and
                (element == .SubMenu or
                element == .Item or
                element == .Separator))
            {

                // IUP needs a menu inside a subMenu to hold childrens
                var innerMenu: *Handle = undefined;
                if (self.children().next()) |valid| {
                    innerMenu = valid.getHandle();
                } else {
                    if (c.IupMenu(null)) |valid| {
                        if (c.IupAppend(c.getHandle(self), valid) == null) {
                            return Error.InvalidChild;
                        }

                        innerMenu = valid;
                    } else {
                        return Error.NotInitialized;
                    }
                }

                var ret = c.IupAppend(innerMenu, element.getHandle());
                if (ret == null) {
                    return Error.InvalidChild;
                }
            } else {
                var ret = c.IupAppend(c.getHandle(self), element.getHandle());
                if (ret == null) {
                    return Error.InvalidChild;
                }
            }
        }

        fn appendDialogSubMenu(self: *T, submenu: *SubMenu) !void {
            if (T == Dialog) {
                if (self.getMenu()) |top_level_menu| {
                    try top_level_menu.appendChild(submenu);
                } else {
                    var menu = try (Menu.init()
                        .setChildren(
                        .{
                            submenu,
                        },
                    ).unwrap());

                    self.setMenu(menu);
                }
            } else {
                return Error.InvalidChild;
            }
        }

        ///
        /// Converts a (lin, col) character positioning into an absolute position. lin and col starts at 1, pos starts at 0. For single line controls pos is always ""col - 1"". (since 3.0)
        pub fn convertLinColToPos(self: *T, lin: i32, col: i32) ?i32 {
            const UNINITALIZED = std.math.minInt(i32);
            var pos: i32 = UNINITALIZED;

            c.IupTextConvertLinColToPos(c.getHandle(self), lin, col, &pos);

            if (pos == UNINITALIZED) {
                return null;
            } else {
                return pos;
            }
        }

        ///
        /// Converts a (lin, col) character positioning into an absolute position. lin and col starts at 1, pos starts at 0. For single line controls pos is always ""col - 1"". (since 3.0)
        pub fn convertPosToLinCol(self: *T, pos: i32) ?iup.LinColPos {
            const UNDEFINED = std.math.minInt(i32);
            var lin: i32 = UNDEFINED;
            var col: i32 = UNDEFINED;

            c.IupTextConvertPosToLinCol(c.getHandle(self), pos, &lin, &col);

            if (lin == UNDEFINED or col == UNDEFINED) {
                return null;
            } else {
                return iup.LinColPos{ .lin = lin, .col = col };
            }
        }

        pub fn messageDialogAlert(parent: ?*Dialog, title: ?[:0]const u8, message: [:0]const u8) !void {
            
            var dialog = try (iup.MessageDlg.init()
                .setValue(message)
                .setDialogType(.Warning)
                .unwrap());
            defer dialog.deinit();

            if (title) |valid| dialog.setTitle(valid);
            
            if (parent) |valid| {
                if (title == null) dialog.setTitle(valid.getTitle());
                dialog.setParentDialog(valid);
            }
            _ = dialog.popup(.CenterParent, .CenterParent);
        }

        pub fn messageDialogConfirm(parent: ?*Dialog, title: ?[:0]const u8, message: [:0]const u8) !bool {
            var dialog = try (iup.MessageDialog.init()
                .setValue(message)
                .setDialogType(.Question)
                .setButtons(.YesNo)
                .unwrap());
            defer dialog.deinit();

            if (title) |valid| dialog.setTitle(valid);
            
            if (parent) |valid| {
                if (title == null) dialog.setTitle(valid.getTitle());
                dialog.setParentDialog(valid);
            }
            _ = dialog.popup(.Center, .Center);            

            var ret = dialog.popup(.CenterParent, .CenterParent);
            return ret == .Button1;
        }       
    };
}

/// Helper functions
fn getArgsLen(comptime T: type) comptime_int {
    if (!comptime trait.isTuple(T)) {
        @compileError("Expected tuple argument, found " ++ @typeName(T));
    }

    return @typeInfo(T).Struct.fields.len + 1;
}

fn getArgHandle(arg: anytype) !Element {
    const argType = @TypeOf(arg);
    if (argType == Element) return arg;

    const argTypeInfo = @typeInfo(argType);
    const errorMessage = "Tuple argument " ++ @typeName(argType) ++ " no supported";

    switch (argTypeInfo) {
        .Struct => {
            if (comptime canUnwrap(argType)) {

                // Verify previous errors
                var value = try arg.unwrap();
                return Element.fromRef(value);
            } else {
                @compileError(errorMessage);
            }
        },
        .Pointer => |pointerInfo| {
            const pointerTypeInfo = @typeInfo(pointerInfo.child);

            if (pointerTypeInfo == .Struct) {
                if (comptime canUnwrap(pointerInfo.child)) {

                    // Verify previous errors
                    var value = try arg.unwrap();
                    return Element.fromRef(value);
                } else {
                    @compileError(errorMessage);
                }
            } else {
                return Element.fromType(@TypeOf(arg), arg);
            }
        },
        else => @compileError(errorMessage),
    }
}

fn canUnwrap(comptime T: type) bool {
    return comptime trait.hasFunctions(T, .{"unwrap"});
}
