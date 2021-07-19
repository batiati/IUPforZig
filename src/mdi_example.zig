/// Creates a tree with some branches and leaves. 
/// Two callbacks are registered: one deletes marked nodes when the Del key is pressed, 
/// and the other, called when the right mouse button is pressed, opens a menu with options.
/// From original example in C
/// https://webserver2.tecgraf.puc-rio.br/iup/examples/C/mdi.c
const std = @import("std");
const iup = @import("iup.zig");

var dlg_id: i32 = 0;
var allocator: *std.mem.Allocator = undefined;
usingnamespace iup;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    allocator = &gpa.allocator;

    try MainLoop.open();
    defer MainLoop.close();

    var dlg = try createParentMdi();
    defer dlg.deinit();

    try dlg.showXY(.Center, .Center);

    try MainLoop.beginLoop();
}

fn createParentMdi() !*Dialog {
    var win_menu = try (Menu.init()
        .setChildren(
        .{
            Item.init()
                .setActionCallback(onTileHorizontal)
                .setTitle("Tile Horizontal"),
            Item.init()
                .setActionCallback(onTileVertical)
                .setTitle("Tile Vertical"),
            Item.init()
                .setActionCallback(onCascade)
                .setTitle("Cascade"),
            Item.init()
                .setActionCallback(onIconArrange)
                .setTitle("Icon Arrange"),
            Item.init()
                .setActionCallback(onCloseAll)
                .setTitle("Close All"),
            Separator.init(),
            Item.init()
                .setActionCallback(onNext)
                .setTitle("Next"),
            Item.init()
                .setActionCallback(onPrevious)
                .setTitle("Previous"),
        },
    ).unwrap());

    var menu = try (Menu.init().setChildren(
        .{
            SubMenu.init()
                .setTitle("MDI")
                .setChildren(
                .{
                    Item.init()
                        .setTitle("New")
                        .setActionCallback(onNewChild),
                },
            ),
            SubMenu.init()
                .setTitle("Window")
                .setChildren(
                .{
                    win_menu,
                },
            ),
        },
    ).unwrap());

    return try (Dialog.init()
        .setMdiFrame(true)
        .setRasterSize(800, 600)
        .setTitle("MDI Frame")
        .setMenu(menu)
        .setChildren(
        .{
            Canvas.init()
                .setMdiMenu(win_menu)
                .setMdiClient(true),
        },
    ).unwrap());
}

fn createDialog(parent: *Dialog, id: i32) !*Dialog {
    const title = try std.fmt.allocPrintZ(allocator, "MDI Child ({})", .{id});
    defer allocator.free(title);

    var img1 = try images.getImg1();
    var img2 = try images.getImg2();

    var frame1 = Frame.init()
        .setTitle("IupButton")
        .setChildren(
        .{
            VBox.init()
                .setChildren(
                .{
                    Button.init()
                        .setTitle("Button Text"),
                    Button.init()
                        .setBgColor(.{ .r = 255, .g = 128, .b = 0 })
                        .setRasterSize(30, 30),
                    Button.init()
                        .setImage(img1),
                    Button.init()
                        .setImage(img1)
                        .setFlat(true),
                    Button.init()
                        .setImage(img1)
                        .setImPress(img2),
                },
            ),
        },
    );

    var frame2 = Frame.init()
        .setTitle("IupLabel")
        .setChildren(
        .{
            VBox.init()
                .setChildren(
                .{
                    Label.init()
                        .setTitle("Label Text\nLine 2\nLine 3"),
                    Label.init()
                        .setSeparator(.Horizontal),
                    Label.init()
                        .setImage(img1),
                },
            ),
        },
    );

    var frame3 = Frame.init()
        .setTitle("IupToggle")
        .setChildren(
        .{
            VBox.init()
                .setChildren(
                .{
                    Toggle.init()
                        .setTitle("Toggle Text")
                        .setValue(.On),
                    Toggle.init()
                        .setTitle("3State Text")
                        .set3State(true)
                        .setValue(.NotDef),
                    Toggle.init()
                        .setImage(img1)
                        .setImPress(img2),
                    Frame.init()
                        .setTitle("IupRadio")
                        .setChildren(
                        .{
                            Radio.init()
                                .setChildren(
                                .{
                                    VBox.init().setChildren(
                                        .{
                                            Toggle.init()
                                                .setTitle("Toggle Text"),
                                            Toggle.init()
                                                .setTitle("Toggle Text"),
                                        },
                                    ),
                                },
                            ),
                        },
                    ),
                },
            ),
        },
    );

    var frame4 = Frame.init()
        .setTitle("IupText/IupMultiline")
        .setChildren(
        .{
            VBox.init()
                .setChildren(
                .{
                    Text.init()
                        .setSize(80, null)
                        .setValue("IupText Text"),
                    Multiline.init()
                        .setSize(80, 60)
                        .setExpand(.Yes)
                        .setValue(
                        \\IupMultiline Text
                        \\Second Line
                        \\Third Line
                    ),
                },
            ),
        },
    );

    var frame5 = Frame.init()
        .setTitle("IupList")
        .setChildren(
        .{
            VBox.init()
                .setChildren(
                .{
                    List.init()
                        .setExpand(.Yes)
                        .setMultiple(true)
                        .setValue("1")
                        .setItems(1, "Item 1 Text")
                        .setItems(2, "Item 2 Text")
                        .setItems(3, "Item 3 Text Big Item")
                        .setItems(4, "Item 4 Text")
                        .setItems(5, "Item 5 Text")
                        .setItems(6, "Item 6 Text"),
                    List.init()
                        .setDropDown(true)
                        .setExpand(.Yes)
                        .setVisibleItems(3)
                        .setValue("2")
                        .setItems(1, "Item 1 Text")
                        .setItems(2, "Item 2 Text")
                        .setItems(3, "Item 3 Text Big Item")
                        .setItems(4, "Item 4 Text")
                        .setItems(5, "Item 5 Text")
                        .setItems(6, "Item 6 Text"),
                    List.init()
                        .setEditBox(true)
                        .setExpand(.Yes)
                        .setValue("Test Value")
                        .setItems(1, "Item 1 Text")
                        .setItems(2, "Item 2 Text")
                        .setItems(3, "Item 3 Text Big Item")
                        .setItems(4, "Item 4 Text")
                        .setItems(5, "Item 5 Text")
                        .setItems(6, "Item 6 Text"),
                },
            ),
        },
    );

    return try (Dialog.init()
        .setTitle(title)
        .setParentDialog(parent)
        .setMdiChild(true)
        .setChildren(
        .{
            VBox.init()
                .setMargin(5, 5)
                .setAlignment(.ARight)
                .setGap(5)
                .setChildren(
                .{
                    HBox.init().setChildren(
                        .{
                            frame1,
                            frame2,
                            frame3,
                            frame4,
                            frame5,
                        },
                    ),
                    Canvas.init(),
                },
            ),
        },
    )
        .unwrap());
}

fn onNewChild(item: *Item) !void {
    var parent = item.getDialog() orelse unreachable;
    dlg_id += 1;
    var dlg = try createDialog(parent, dlg_id);
    try dlg.show();
}

fn onTileHorizontal(item: *Item) !void {
    var dlg = item.getDialog() orelse unreachable;
    dlg.mdiArrange(.TileHorizontal);
}

fn onTileVertical(item: *Item) !void {
    var dlg = item.getDialog() orelse unreachable;
    dlg.mdiArrange(.TileVertical);
}

fn onCascade(item: *Item) !void {
    var dlg = item.getDialog() orelse unreachable;
    dlg.mdiArrange(.Cascade);
}

fn onIconArrange(item: *Item) !void {
    var dlg = item.getDialog() orelse unreachable;
    dlg.mdiArrange(.Icon);
}

fn onCloseAll(item: *Item) !void {
    var dlg = item.getDialog() orelse unreachable;
    dlg.mdiCloseAll();
}

fn onNext(item: *Item) !void {
    _ = item;
}

fn onPrevious(item: *Item) !void {
    _ = item;
}

const images = struct {
    const bits_1 = [_]u8{ // zig fmt: off
       1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1
      ,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1
      ,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1
      ,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1
      ,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1
      ,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1
      ,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1
      ,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1
      ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
      ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
      ,2,2,2,0,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
      ,2,2,2,0,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
      ,2,2,2,0,2,0,2,0,2,2,0,2,2,2,0,0,0,2,2,2,0,0,2,0,2,2,0,0,0,2,2,2
      ,2,2,2,0,2,0,0,2,0,0,2,0,2,0,2,2,2,0,2,0,2,2,0,0,2,0,2,2,2,0,2,2
      ,2,2,2,0,2,0,2,2,0,2,2,0,2,2,2,2,2,0,2,0,2,2,2,0,2,0,2,2,2,0,2,2
      ,2,2,2,0,2,0,2,2,0,2,2,0,2,2,0,0,0,0,2,0,2,2,2,0,2,0,0,0,0,0,2,2
      ,2,2,2,0,2,0,2,2,0,2,2,0,2,0,2,2,2,0,2,0,2,2,2,0,2,0,2,2,2,2,2,2
      ,2,2,2,0,2,0,2,2,0,2,2,0,2,0,2,2,2,0,2,0,2,2,0,0,2,0,2,2,2,0,2,2
      ,2,2,2,0,2,0,2,2,0,2,2,0,2,2,0,0,0,0,2,2,0,0,2,0,2,2,0,0,0,2,2,2
      ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,0,2,2,2,2,2,2,2,2
      ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,0,2,2,2,0,2,2,2,2,2,2,2,2
      ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,0,0,0,2,2,2,2,2,2,2,2,2
      ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
      ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
      ,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1
      ,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1
      ,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1
      ,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1
      ,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
      ,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
      ,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
      ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1    
    }; // zig fmt: on

    const bits_2 = [_]u8{ // zig fmt: off
       2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2
      ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2
      ,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2
      ,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2
      ,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2
      ,2,2,2,2,2,2,2,2,2,2,3,3,3,3,1,1,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2
      ,2,2,2,2,2,2,2,2,2,3,3,3,3,3,1,1,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2
      ,2,2,2,2,2,2,2,2,3,3,3,3,3,3,1,1,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2
      ,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
      ,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
      ,3,3,3,0,3,3,3,3,3,3,3,3,3,3,1,1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
      ,3,3,3,0,3,3,3,3,3,3,3,3,3,3,1,1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
      ,3,3,3,0,3,0,3,0,3,3,0,3,3,3,1,1,0,3,3,3,0,0,3,0,3,3,0,0,0,3,3,3
      ,3,3,3,0,3,0,0,3,0,0,3,0,3,0,1,1,3,0,3,0,3,3,0,0,3,0,3,3,3,0,3,3
      ,3,3,3,0,3,0,3,3,0,3,3,0,3,3,1,1,3,0,3,0,3,3,3,0,3,0,3,3,3,0,3,3
      ,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
      ,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
      ,3,3,3,0,3,0,3,3,0,3,3,0,3,0,1,1,3,0,3,0,3,3,0,0,3,0,3,3,3,0,3,3
      ,3,3,3,0,3,0,3,3,0,3,3,0,3,3,1,1,0,0,3,3,0,0,3,0,3,3,0,0,0,3,3,3
      ,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,1,3,3,3,3,3,3,3,0,3,3,3,3,3,3,3,3
      ,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,1,3,3,3,0,3,3,3,0,3,3,3,3,3,3,3,3
      ,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,1,3,3,3,3,0,0,0,3,3,3,3,3,3,3,3,3
      ,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
      ,3,3,3,3,3,3,3,3,3,3,3,3,3,3,1,1,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3
      ,2,2,2,2,2,2,2,3,3,3,3,3,3,3,1,1,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2
      ,2,2,2,2,2,2,3,3,3,3,3,3,3,3,1,1,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2
      ,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2
      ,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2
      ,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
      ,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
      ,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
      ,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
    }; // zig fmt: on

    pub fn getImg1() !*Image {
        return try (Image.init(32, 32, bits_1[0..])
            .setHandle("img1")
            .setColors(0, .{ .r = 0, .g = 0, .b = 0 })
            .setColors(1, Rgb.BG_COLOR)
            .setColors(2, .{ .r = 255, .g = 0, .b = 0 })
            .unwrap());
    }

    pub fn getImg2() !*Image {
        return try (Image.init(32, 32, bits_2[0..])
            .setHandle("img2")
            .setColors(0, .{ .r = 0, .g = 0, .b = 0 })
            .setColors(1, .{ .r = 0, .g = 255, .b = 0 })
            .setColors(2, Rgb.BG_COLOR)
            .setColors(3, .{ .r = 255, .g = 0, .b = 0 })
            .unwrap());
    }
};
