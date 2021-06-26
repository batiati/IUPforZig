const std = @import("std");
const iup = @import("iup.zig");

const allocator = std.heap.c_allocator;
usingnamespace iup;

pub fn main() !void {
    try MainLoop.open();
    defer MainLoop.close();

    var notepad = try Notepad.init();
    defer notepad.deinit();

    try notepad.show();

    try MainLoop.beginLoop();
}

pub const Notepad = struct {
    main_dialog: *Dialog = undefined,

    pub const statusbar_name = "statusbar";
    pub const toolbar_name = "toolbar";
    pub const multiline_name = "multiline";
    pub const Self = @This();

    pub fn init() !Self {
        var instance = Self{};
        try instance.createComponents();

        return instance;
    }

    pub fn deinit(self: *Self) void {
        self.main_dialog.deinit();
    }

    pub fn show(self: *Self) !void {
        try self.main_dialog.showXY(.Center, .Center);
    }

    fn createComponents(self: *Self) !void {
        self.main_dialog = try (Dialog.init()
            .setSize(.Half, .Half)
            .setTitle("Simple Notepad")
            .setChildren(
            .{
                createMenu(self),
                VBox.init()
                    .setChildren(
                    .{
                        createToolbar(self),
                        Multiline.init()
                            .setCaretCallback(onCarret)
                            .setName(multiline_name)
                            .setMultiline(true)
                            .setExpand(.Yes),
                        Label.init()
                            .setName(statusbar_name)
                            .setExpand(.Horizontal)
                            .setPadding(10, 5),
                    },
                ),
            },
        ).unwrap());
    }

    fn createMenu(self: *Self) Menu.Initializer {
        _ = self;

        return Menu.init()
            .setChildren(
            .{
                SubMenu.init()
                    .setTitle("File")
                    .setChildren(
                    .{
                        Item.init()
                            .setTitle("&Open ...\tCtrl+O")
                            .setActionCallback(onItemOpen),
                        Item.init()
                            .setTitle("&Save ...\tCtrl+S"),
                        Separator.init(),
                        Item.init()
                            .setTitle("Close")
                            .setActionCallback(onItemClose),
                    },
                ),
                SubMenu.init()
                    .setTitle("Edit")
                    .setChildren(
                    .{
                        Item.init().setTitle("Find ...\tCtrl+F"),
                        Item.init().setTitle("&Go To ...\tCtrl+G")
                            .setActionCallback(onGoTo),
                    },
                ),
                SubMenu.init()
                    .setTitle("Format")
                    .setChildren(
                    .{
                        Item.init().setTitle("Font ..."),
                    },
                ),
                SubMenu.init()
                    .setTitle("View")
                    .setChildren(
                    .{
                        Item.init().setTitle("Toolbar")
                            .setActionCallback(onToggleToolbar)
                            .setAutoToggle(true)
                            .setValue(.On),
                        Item.init().setTitle("Statusbar")
                            .setActionCallback(onToggleStatusbar)
                            .setAutoToggle(true)
                            .setValue(.On),
                    },
                ),
                SubMenu.init()
                    .setTitle("Help")
                    .setChildren(
                    .{
                        Item.init().setTitle("About ..."),
                    },
                ),
            },
        );
    }

    fn createToolbar(_: *Self) HBox.Initializer {
        return HBox.init()
            .setName(toolbar_name)
            .setMargin(5, 5)
            .setGap(2)
            .setChildren(
            .{
                Button.init()
                    .setActionCallback(onButtonOpen)
                    .setCanFocus(false)
                    .setFlat(true)
                    .setTip("Open (Crtl+O)")
                    .setImage("IUP_FileOpen"),
                Button.init()
                    .setActionCallback(onButtonSave)
                    .setCanFocus(false)
                    .setFlat(true)
                    .setTip("Save (Crtl+S)")
                    .setImage("IUP_FileSave"),
                Label.init().setSeparator(.Vertical),
                Button.init()
                    .setActionCallback(onButtonFind)
                    .setCanFocus(false)
                    .setFlat(true)
                    .setTip("Find (Crtl+F)")
                    .setImage("IUP_EditFind"),
            },
        );
    }

    fn open(element: anytype) !void {
        const filter = "Text Files|*.txt|All Files|*.*|";
        var parent = element.getDialog() orelse unreachable;
        var fileDlg: *FileDlg = try (FileDlg.init()
            .setParentDialog(parent)
            .setDialogType(.Open)
            .setExtFilter(filter)
            .unwrap());
        defer fileDlg.deinit();

        fileDlg.popup(.CenterParent, .CenterParent);

        if (fileDlg.getStatus() != .Cancelled) {
            var fileName = fileDlg.getValue();

            var file = std.fs.openFileAbsolute(fileName, .{}) catch {
                return;
            };
            defer file.close();

            var content = try file.readToEndAllocOptions(allocator, std.math.maxInt(u64), null, @alignOf(u8), 0);
            defer allocator.free(content);

            var text = element.getDialogChild(multiline_name).?.Multiline;
            text.setValue(content);

            try refreshStatusBar(text);
        }
    }

    fn refreshStatusBar(sender: anytype) !void {
        var text: *Multiline = sender.getDialogChild(multiline_name).?.Multiline;
        var label: *Label = sender.getDialogChild(statusbar_name).?.Label;

        var pos = text.getCaret();

        var title = try std.fmt.allocPrintZ(allocator, "Lin {}, Col {}", .{ pos.lin, pos.col });
        defer allocator.free(title);

        label.setTitle(title);
    }

    fn find(text: *Multiline) !void {
        _ = find_dialog.popup(text);
    }

    fn onButtonOpen(button: *Button) !void {
        try open(button);
    }

    fn onItemOpen(item: *Item) !void {
        try open(item);
    }

    fn onButtonSave(_: *Button) !void {
        //TODO
    }

    fn onButtonFind(button: *Button) !void {
        var text = button.getDialogChild(multiline_name).?.Multiline;
        try find(text);
    }

    fn onItemClose(_: *Item) !void {
        MainLoop.close();
    }

    fn onGoTo(item: *Item) !void {
        var text = item.getDialogChild(multiline_name).?.Multiline;
        var success = goto_dialog.popup(text);
        if (success) try refreshStatusBar(item);
    }

    fn onToggleToolbar(item: *Item) !void {
        var hbox = item.getDialogChild(toolbar_name).?.HBox;
        var visible = if (item.getValue()) |value| value == .On else false;
        hbox.setVisible(visible);
        hbox.setFloating(if (visible) null else .Yes);
        hbox.refresh();
    }

    fn onToggleStatusbar(item: *Item) !void {
        var label = item.getDialogChild(statusbar_name).?.Label;
        var visible = if (item.getValue()) |value| value == .On else false;
        label.setVisible(visible);
        label.setFloating(if (visible) null else .Yes);
        label.refresh();
    }

    fn onCarret(text: *Multiline, lin: i32, col: i32, _: i32) !void {
        _ = lin;
        _ = col;

        try refreshStatusBar(text);
    }
};

const find_dialog = struct {
    const multiline_name = "multiline";
    const find_text_name = "find_text";
    const case_toggle_name = "case";

    ///
    /// Shows "Find" dialog
    pub fn popup(text: *Multiline) bool {
        var parent = text.getDialog() orelse unreachable;

        var dlg = createDialog(parent) catch unreachable;
        defer dlg.deinit();

        dlg.popup(.CenterParent, .CenterParent);
        return true;
    }

    fn onNext(button: *Button) !void {
        try find(button);
    }

    fn onClose(button: *Button) !void {
        var dialog = button.getDialog() orelse unreachable;
        try dialog.hide();
    }

    fn createDialog(parent: *Dialog) !*Dialog {
        var multiline = parent.getDialogChild(multiline_name).?.Multiline;

        var next_button: *Button = undefined;
        var close_button: *Button = undefined;

        return try (Dialog.init()
            .setPtrAttribute(Multiline, multiline_name, multiline)
            .setParentDialog(parent)
            .setDialogFrame(true)
            .setTitle("Find")
            .setChildren(
            .{
                VBox.init()
                    .setMargin(10, 10)
                    .setGap(5)
                    .setChildren(
                    .{
                        Label.init()
                            .setTitle("Find what:"),
                        Text.init()
                            .setName(find_text_name)
                            .setVisibleColumns(20),
                        Toggle.init()
                            .setName(case_toggle_name)
                            .setTitle("Case sensitive"),
                        HBox.init()
                            .setNormalizeSize(.Horizontal)
                            .setChildren(
                            .{
                                Fill.init(),
                                Button.init()
                                    .capture(&next_button)
                                    .setActionCallback(onNext)
                                    .setPadding(10, 2)
                                    .setTitle("Find next"),
                                Button.init()
                                    .capture(&close_button)
                                    .setActionCallback(onClose)
                                    .setPadding(10, 2)
                                    .setTitle("Close"),
                            },
                        ),
                    },
                ),
            },
        )
            .setDefaultEsc(close_button)
            .setDefaultEnter(next_button)
            .unwrap());
    }

    fn find(element: anytype) !void {
        var dlg = element.getDialog() orelse unreachable;
        try MessageDlg.alert(dlg, null, "Not implemented!");
    }
};

///
/// Goto-line dialog
const goto_dialog = struct {
    const line_textbox = "line";
    const line_count_attr = "line_count";
    const go_to_attr = "go_to";

    ///
    /// Shows "Go To line" dialog
    pub fn popup(text: *Multiline) bool {
        var parent = text.getDialog() orelse unreachable;
        var line_count = text.getLineCount();

        var dlg = createDialog(parent, line_count) catch unreachable;
        defer dlg.deinit();

        dlg.popup(.CenterParent, .CenterParent);

        var go_to = dlg.getIntAttribute(go_to_attr);
        if (go_to > 0) {
            if (text.convertLinColToPos(go_to, 0)) |pos| {
                text.setCaretPos(pos);
                text.scrollTopOs(pos);
                return true;
            }
        }

        return false;
    }

    fn createDialog(parent: *Dialog, line_count: i32) !*Dialog {
        var title = try std.fmt.allocPrintZ(allocator, "Line Number [1-{}]:", .{line_count});
        defer allocator.free(title);

        var ok_button: *Button = undefined;
        var cancel_button: *Button = undefined;

        return try (Dialog.init()
            .setParentDialog(parent)
            .setIntAttribute(line_count_attr, line_count)
            .setTitle("Go To Line")
            .setDialogFrame(true)
            .setChildren(
            .{
                VBox.init()
                    .setMargin(10, 10)
                    .setGap(5)
                    .setChildren(
                    .{
                        Label.init()
                            .setTitle(title),
                        Text.init()
                            .setMask(masks.u_int)
                            .setName(line_textbox)
                            .setVisibleColumns(20),
                        HBox.init().setChildren(
                            .{
                                Fill.init(),
                                Button.init()
                                    .capture(&ok_button)
                                    .setTitle("Go to line")
                                    .setPadding(10, 2)
                                    .setActionCallback(onButtonOk),
                                Button.init()
                                    .capture(&cancel_button)
                                    .setTitle("Cancel")
                                    .setPadding(10, 2)
                                    .setActionCallback(onButtonCancel),
                            },
                        ),
                    },
                ),
            },
        )
            .setDefaultEnter(ok_button)
            .setDefaultEsc(cancel_button)
            .unwrap());
    }

    fn onButtonOk(button: *Button) !void {
        var dlg = button.getDialog() orelse unreachable;
        var txt = dlg.getDialogChild(line_textbox).?.Text;

        var go_to = std.fmt.parseInt(i32, txt.getValue(), 10) catch {
            try MessageDlg.alert(dlg, null, "Invalid line number!");
            return;
        };

        var line_count = dlg.getIntAttribute(line_count_attr);

        if (go_to < 1 or go_to > line_count) {
            try MessageDlg.alert(dlg, null, "Invalid line number!");
            return;
        }

        dlg.setIntAttribute(go_to_attr, go_to);
        try dlg.hide();
    }

    fn onButtonCancel(button: *Button) !void {
        var dlg = button.getDialog() orelse unreachable;
        dlg.setIntAttribute(go_to_attr, 0);
        try dlg.hide();
    }
};
