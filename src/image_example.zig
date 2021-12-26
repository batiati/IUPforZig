///
/// Creates a button, a label, a toggle and a radio using an image. Uses an image for the cursor as well.
/// From original example in C
/// https://webserver2.tecgraf.puc-rio.br/iup/examples/C/image.c
const std = @import("std");
const iup = @import("iup.zig");

const fmt = std.fmt;

const MainLoop = iup.MainLoop;
const Dialog = iup.Dialog;
const Button = iup.Button;
const MessageDlg = iup.MessageDlg;
const Multiline = iup.Multiline;
const Label = iup.Label;
const Text = iup.Text;
const VBox = iup.VBox;
const HBox = iup.HBox;
const Menu = iup.Menu;
const SubMenu = iup.SubMenu;
const Separator = iup.Separator;
const Fill = iup.Fill;
const Item = iup.Item;
const FileDlg = iup.FileDlg;
const Toggle = iup.Toggle;
const Tabs = iup.Tabs;
const Frame = iup.Frame;
const Radio = iup.Radio;
const ScreenSize = iup.ScreenSize;
const Image = iup.Image;
const ImageRgb = iup.ImageRgb;
const ImageRgba = iup.ImageRgba;

var allocator: std.mem.Allocator = undefined;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    allocator = gpa.allocator();

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
        .setCursor(img_cursor)
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
                                                .setImage(img_x),
                                        },
                                    ),
                                    Frame.init()
                                        .setSize(60, 60)
                                        .setTitle("label")
                                        .setChildren(
                                        .{
                                            Label.init()
                                                .setImage(img_x),
                                        },
                                    ),
                                    Frame.init()
                                        .setSize(60, 60)
                                        .setTitle("toggle")
                                        .setChildren(
                                        .{
                                            Toggle.init()
                                                .setImage(img_x),
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
                                                                .setImage(img_x),
                                                            Toggle.init()
                                                                .setImage(img_x),
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
            .setHandle("img_x")
            .setColors(1, .{ .r = 0, .g = 1, .b = 0 })
            .setColors(2, .{ .r = 255, .g = 0, .b = 0 })
            .setColors(3, .{ .r = 255, .g = 255, .b = 0 })
            .unwrap());
    }

    pub fn getCursor() !*Image {
        return try (Image.init(32, 32, pixelmap_cursor[0..])
            .setHandle("img_cursor ")
            .setHotspot(21, 10)
            .setColors(1, .{ .r = 255, .g = 0, .b = 0 })
            .setColors(2, .{ .r = 128, .g = 0, .b = 0 })
            .unwrap());
    }
};
