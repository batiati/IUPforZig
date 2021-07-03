/// From original example in C
/// https://webserver2.tecgraf.puc-rio.br/iup/examples/C/tabs.c
const std = @import("std");
const iup = @import("iup.zig");

usingnamespace iup;

pub fn main() !void {
    try MainLoop.open();
    defer MainLoop.close();

    var dlg = try create_dialog();
    defer dlg.deinit();

    try dlg.showXY(.Center, .Center);

    try MainLoop.beginLoop();
}

fn create_dialog() !*Dialog {
    var tabs1 = Tabs.init()
        .setTabTitle(0, "TAB A")
        .setTabTitle(1, "TAB B")
        .setChildren(
        .{
            VBox.init()
                .setChildren(
                .{
                    Label.init().setTitle("Inside Tab A"),
                    Button.init().setTitle("Button A"),
                },
            ),
            VBox.init()
                .setChildren(
                .{
                    Label.init().setTitle("Inside Tab B"),
                    Button.init().setTitle("Button B"),
                },
            ),
        },
    );

    var tabs2 = Tabs.init()
        .setTabType(.Left)
        .setTabTitle(0, "TAB C")
        .setTabTitle(1, "TAB D")
        .setChildren(
        .{
            VBox.init()
                .setChildren(
                .{
                    Label.init().setTitle("Inside Tab C"),
                    Button.init().setTitle("Button C"),
                },
            ),
            VBox.init()
                .setChildren(
                .{
                    Label.init().setTitle("Inside Tab D"),
                    Button.init().setTitle("Button D"),
                },
            ),
        },
    );

    return try (Dialog.init()
        .setTitle("IUP for Zig - Tabs")
        .setSize(ScreenSize{ .Size = 200 }, ScreenSize{ .Size = 90 })
        .setChildren(
        .{
            HBox.init()
                .setMargin(10, 10)
                .setGap(10)
                .setChildren(
                .{
                    tabs1,
                    tabs2,
                },
            ),
        },
    ).unwrap());
}
