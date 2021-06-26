///
/// Creates a button, a label, a toggle and a radio using an image. Uses an image for the cursor as well.
/// From original example in C
/// https://webserver2.tecgraf.puc-rio.br/iup/examples/C/image.c
const std = @import("std");
const iup = @import("iup.zig");

const allocator = std.heap.c_allocator;
const fmt = std.fmt;

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
    var img_x = try images.getX();
    var img_cursor = try images.getCursor();

    var str_size = try fmt.allocPrintZ(allocator, "\"X\" image width = {}; \"X\" image height = {}", .{ img_x.getWidth(), img_x.getHeight() });
    defer allocator.free(str_size);

    return try (Dialog.init()
        .setTitle("IUPforZig - Images")
        .setSize(.Third, .Quarter)
        .setCursor(img_cursor.getHandleName())
        .setChildren(
        .{
            VBox.init()
                .setChildren(
                .{
                    VBox.init()
                        .setMargin(2, 2)
                        .setChildren(
                        .{
                            HBox.init()
                                .setGap(5)
                                .setChildren(
                                .{
                                    Frame.init()
                                        .setSize(60, 60)
                                        .setTitle("button")
                                        .setChildren(
                                        .{
                                            Button.init()
                                                .setImage(img_x.getHandleName()),
                                        },
                                    ),
                                    Frame.init()
                                        .setSize(60, 60)
                                        .setTitle("label")
                                        .setChildren(
                                        .{
                                            Label.init()
                                                .setImage(img_x.getHandleName()),
                                        },
                                    ),
                                    Frame.init()
                                        .setSize(60, 60)
                                        .setTitle("toggle")
                                        .setChildren(
                                        .{
                                            Toggle.init()
                                                .setImage(img_x.getHandleName()),
                                        },
                                    ),
                                    Frame.init()
                                        .setSize(60, 60)
                                        .setTitle("radio")
                                        .setChildren(
                                        .{
                                            Radio.init()
                                                .setChildren(
                                                .{
                                                    VBox.init()
                                                        .setChildren(
                                                        .{
                                                            Toggle.init()
                                                                .setImage(img_x.getHandleName()),
                                                            Toggle.init()
                                                                .setImage(img_x.getHandleName()),
                                                        },
                                                    ),
                                                },
                                            ),
                                        },
                                    ),
                                },
                            ),
                            Fill.init(),
                            HBox.init()
                                .setChildren(
                                .{
                                    Fill.init(),
                                    Label.init().setTitle(str_size),
                                    Fill.init(),
                                },
                            ),
                        },
                    ),
                },
            ),
        },
    )
        .unwrap());
}

const images = struct {
    const pixelmap_x = [_]u8{ // zig fmt: off
        1,2,3,3,3,3,3,3,3,2,1, 
        2,1,2,3,3,3,3,3,2,1,2, 
        3,2,1,2,3,3,3,2,1,2,3, 
        3,3,2,1,2,3,2,1,2,3,3, 
        3,3,3,2,1,2,1,2,3,3,3, 
        3,3,3,3,2,1,2,3,3,3,3, 
        3,3,3,2,1,2,1,2,3,3,3, 
        3,3,2,1,2,3,2,1,2,3,3, 
        3,2,1,2,3,3,3,2,1,2,3, 
        2,1,2,3,3,3,3,3,2,1,2, 
        1,2,3,3,3,3,3,3,3,2,1
    }; // zig fmt: on

    const pixelmap_cursor = [_]u8{ // zig fmt: off
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,2,2,2,2,2,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,1,1,1,1,2,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,1,1,1,1,2,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,1,1,1,1,1,2,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,2,1,1,1,1,1,1,2,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,2,1,1,1,1,1,2,2,2,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,2,1,1,1,1,1,2,0,0,2,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,2,1,1,1,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
    }; // zig fmt: on

    pub fn getX() !*Image {
        return try (Image.init(11, 11, pixelmap_x[0..])
            .setHandleName("img_x")
            .setColors(1, .{ .r = 0, .g = 1, .b = 0 })
            .setColors(2, .{ .r = 255, .g = 0, .b = 0 })
            .setColors(3, .{ .r = 255, .g = 255, .b = 0 })
            .unwrap());
    }

    pub fn getCursor() !*Image {
        return try (Image.init(32, 32, pixelmap_cursor[0..])
            .setHandleName("img_cursor ")
            .setHotspot(21, 10)
            .setColors(1, .{ .r = 255, .g = 0, .b = 0 })
            .setColors(2, .{ .r = 128, .g = 0, .b = 0 })
            .unwrap());
    }
};