/// Creates a dialog with three frames, each one containing a list.
/// The first is a simple list, the second one is a multiple list and the last one is a drop-down list.
/// The second list has a callback associated.
/// From original example in C
/// https://tecgraf.puc-rio.br/iup/examples/C/list1.c
const std = @import("std");
const iup = @import("iup.zig");

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
const List = iup.List;
const Frame = iup.Frame;
const Radio = iup.Radio;
const ScreenSize = iup.ScreenSize;
const Image = iup.Image;
const ImageRgb = iup.ImageRgb;
const ImageRgba = iup.ImageRgba;
const Rgb = iup.Rgb;

pub fn main() !void {
    try MainLoop.open();
    defer MainLoop.close();

    var dlg = try create_dialog();
    defer dlg.deinit();

    try dlg.showXY(.Center, .Center);

    try MainLoop.beginLoop();
}

fn create_dialog() !*Dialog {
    var img_gold = try images.loadGold();
    var img_silver = try images.loadSilver();
    var img_bronze = try images.loadBronze();
    var img_tecgraf = try images.loadTecgraf();
    var img_prize = try images.loadPrize();

    return try (Dialog.init()
        .setTitle("IUPforZig - List")
        .setSize(.Half, .Half)
        .setChildren(
        .{
            HBox.init().setExpandChildren(true)
                .setMargin(5, 5)
                .setGap(5)
                .setChildren(
                .{
                    Frame.init()
                        .setTitle("Best Medal")
                        .setChildren(
                        .{List.init()
                            .setExpand(.Yes)
                            .setDragSourceMove(true)
                            .setDragSource(true)
                            .setDragTypes("ITEMLIST")
                            .setDragDropCallback(dragdrop_cb)
                            .setSpacing(4)
                            .setShowDragDrop(true)
                            .setShowImage(true)
                            .setItems(1, "Gold")
                            .setItems(2, "Silver")
                            .setItems(3, "Bronze")
                            .setItems(4, "Tecgraf")
                            .setItems(5, "None")
                            .image(1, img_gold)
                            .image(2, img_silver)
                            .image(3, img_bronze)
                            .image(4, img_tecgraf)},
                    ),
                    Frame.init()
                        .setTitle("Competed in")
                        .setChildren(
                        .{
                            List.init()
                                .setExpand(.Yes)
                                .setActionCallback(list_multiple_cb)
                                .setMultiple(true)
                                .setItems(1, "100m dash")
                                .setItems(2, "Long jump")
                                .setItems(3, "Javelin throw")
                                .setItems(4, "110m hurdlers")
                                .setItems(5, "Hammer throw")
                                .setItems(6, "High jump"),
                        },
                    ),
                    Frame.init()
                        .setTitle("Prizes won")
                        .setChildren(
                        .{
                            List.init()
                                .setExpand(.Horizontal)
                                .setVisibleItems(3)
                                .setDropDown(true)
                                .setShowImage(true)
                                .setItems(1, "Less than US$ 1,000")
                                .setItems(2, "US$ 2,000")
                                .setItems(3, "US$ 5,000")
                                .setItems(4, "US$ 10,000")
                                .setItems(5, "US$ 20,000")
                                .setItems(6, "US$ 50,000")
                                .setItems(7, "More than US$ 100,000")
                                .image(1, img_prize)
                                .image(2, img_prize)
                                .image(3, img_tecgraf),
                        },
                    ),
                },
            ),
        },
    )
        .unwrap());
}

fn list_multiple_cb(list: *List, value: [:0]const u8, index: i32, selected: i32) !void {
    _ = list;
    const str = if (selected == 0) "deselected" else "selected";
    std.debug.print("Item {} - {s} - {} {s}\n", .{ index, value, selected, str });
}

fn dragdrop_cb(list: *List, drag_id: i32, drop_id: i32, is_shift: i32, is_control: i32) !void {
    _ = list;
    std.debug.print("DRAGDROP_CP ({})->({}) shift={}, crtl={}\n", .{ drag_id, drop_id, is_shift, is_control });
}

const images = struct {
    pub fn loadTecgraf() !*ImageRgba {
        const image_data = [_]u8{ // zig fmt: off
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 88, 95, 108, 1, 90, 100, 117, 99, 123, 138, 166, 126, 137, 152, 181, 60, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 95, 105, 123, 147, 122, 137, 165, 255, 136, 152, 183, 255, 132, 149, 179, 250, 133, 149, 178, 69, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 92, 100, 115, 43, 111, 125, 150, 253, 140, 158, 190, 255, 135, 151, 182, 255, 132, 149, 179, 255, 131, 147, 177, 217, 153, 164, 188, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 102, 113, 134, 148, 134, 151, 182, 255, 137, 154, 185, 255, 115, 129, 154, 252, 114, 128, 155, 255, 130, 146, 175, 255, 132, 147, 175, 71, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 158, 159, 162, 3, 108, 121, 145, 230, 144, 162, 195, 255, 137, 154, 185, 197, 74, 79, 86, 45, 41, 46, 55, 246, 120, 134, 162, 255, 129, 145, 174, 156, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 95, 101, 113, 48, 124, 139, 167, 255, 144, 161, 194, 255, 138, 155, 186, 67, 0, 0, 0, 0, 49, 54, 62, 150, 87, 98, 118, 255, 128, 144, 173, 223, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 102, 113, 132, 105, 137, 154, 185, 255, 139, 156, 188, 231, 143, 159, 187, 3, 0, 0, 0, 0, 64, 68, 76, 61, 70, 79, 95, 255, 127, 143, 172, 254, 134, 149, 175, 25, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 109, 121, 142, 153, 141, 159, 191, 255, 139, 156, 188, 164, 0, 0, 0, 0, 0, 0, 0, 0, 79, 82, 87, 3, 69, 77, 92, 241, 122, 137, 165, 255, 127, 142, 170, 70, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 110, 122, 146, 191, 145, 163, 196, 255, 139, 156, 188, 107, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 77, 86, 101, 190, 115, 129, 156, 255, 126, 141, 170, 113, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 125, 149, 227, 150, 168, 201, 255, 141, 157, 188, 64, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 82, 91, 107, 144, 113, 127, 153, 255, 125, 140, 169, 144, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 163, 165, 167, 2, 112, 125, 150, 252, 155, 173, 203, 255, 143, 159, 189, 26, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 85, 94, 110, 109, 114, 128, 155, 255, 125, 140, 168, 175, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 160, 167, 181, 1, 120, 130, 149, 33, 48, 53, 59, 69, 43, 46, 52, 100, 50, 54, 59, 137, 116, 130, 156, 255, 155, 171, 201, 255, 105, 118, 142, 155, 104, 117, 141, 151, 105, 118, 141, 151, 105, 118, 142, 151, 101, 113, 136, 185, 111, 124, 150, 255, 116, 130, 156, 220, 112, 125, 148, 95, 115, 127, 150, 67, 123, 134, 156, 33, 168, 176, 190, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 119, 129, 147, 5, 109, 121, 142, 71, 106, 118, 140, 140, 105, 117, 140, 197, 107, 120, 144, 242, 120, 135, 162, 255, 123, 137, 163, 255, 44, 49, 58, 255, 28, 32, 39, 255, 125, 139, 164, 255, 150, 167, 197, 255, 138, 155, 186, 255, 131, 148, 178, 255, 125, 141, 170, 255, 119, 134, 162, 255, 114, 128, 154, 255, 108, 122, 147, 255, 104, 117, 141, 255, 102, 115, 138, 255, 103, 116, 139, 255, 107, 120, 145, 255, 111, 124, 149, 245, 113, 126, 151, 200, 113, 127, 152, 140, 116, 129, 154, 71, 122, 135, 158, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 118, 128, 145, 14, 106, 118, 140, 130, 104, 116, 139, 234, 105, 118, 142, 255, 128, 144, 173, 255, 147, 165, 199, 255, 157, 177, 213, 255, 150, 168, 202, 255, 140, 156, 187, 229, 41, 45, 52, 196, 39, 43, 51, 183, 130, 143, 168, 255, 144, 161, 192, 233, 109, 122, 145, 109, 105, 116, 138, 109, 99, 110, 130, 109, 92, 103, 123, 109, 91, 100, 117, 145, 97, 109, 131, 255, 95, 106, 128, 248, 74, 83, 97, 193, 64, 72, 85, 227, 56, 63, 75, 255, 55, 62, 75, 255, 65, 73, 88, 255, 90, 101, 121, 255, 111, 125, 150, 255, 114, 128, 154, 236, 116, 129, 155, 130, 127, 140, 165, 16, 0, 0, 0, 0,
            95, 101, 113, 22, 103, 115, 137, 220, 103, 116, 140, 255, 110, 123, 148, 255, 146, 165, 198, 255, 147, 165, 197, 232, 142, 158, 188, 147, 131, 144, 169, 78, 115, 123, 139, 20, 0, 0, 0, 0, 0, 0, 0, 0, 91, 97, 108, 68, 128, 142, 167, 255, 144, 162, 193, 212, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 95, 100, 107, 31, 120, 135, 163, 255, 133, 150, 180, 231, 0, 0, 0, 0, 0, 0, 0, 0, 86, 89, 93, 20, 50, 54, 61, 73, 37, 40, 46, 141, 33, 36, 42, 230, 46, 52, 63, 255, 107, 120, 144, 255, 116, 130, 157, 255, 118, 133, 159, 223, 132, 147, 174, 24,
            76, 83, 95, 114, 104, 117, 140, 255, 105, 117, 141, 255, 118, 133, 160, 253, 139, 155, 184, 116, 134, 143, 161, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 93, 100, 110, 74, 122, 137, 163, 255, 143, 160, 191, 200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 110, 114, 120, 31, 123, 138, 166, 255, 136, 153, 183, 228, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 90, 93, 97, 5, 42, 45, 51, 111, 86, 97, 117, 253, 118, 133, 160, 255, 119, 133, 161, 255, 133, 149, 180, 116,
            46, 50, 56, 109, 67, 76, 91, 255, 105, 118, 142, 255, 107, 120, 145, 254, 112, 125, 149, 131, 127, 139, 161, 12, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 93, 98, 109, 74, 116, 130, 156, 255, 142, 159, 190, 200, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 112, 115, 122, 31, 128, 143, 172, 255, 141, 157, 185, 228, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 124, 137, 163, 7, 122, 136, 162, 122, 120, 135, 162, 254, 121, 136, 164, 255, 136, 152, 184, 255, 126, 141, 168, 116,
            71, 74, 79, 17, 31, 35, 41, 206, 42, 47, 57, 255, 77, 87, 105, 255, 103, 116, 140, 255, 110, 124, 149, 239, 112, 125, 150, 157, 115, 128, 153, 89, 122, 134, 158, 30, 147, 158, 177, 2, 0, 0, 0, 0, 81, 87, 96, 65, 109, 123, 148, 255, 141, 158, 190, 212, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 98, 103, 112, 31, 135, 151, 180, 255, 141, 156, 183, 231, 0, 0, 0, 0, 153, 164, 183, 1, 134, 147, 171, 30, 124, 138, 165, 84, 123, 138, 165, 154, 122, 137, 164, 235, 127, 143, 172, 255, 140, 157, 189, 255, 144, 162, 195, 255, 129, 144, 172, 218, 126, 138, 161, 22,
            0, 0, 0, 0, 64, 68, 73, 7, 39, 43, 49, 118, 32, 36, 42, 225, 30, 35, 42, 255, 50, 57, 68, 255, 72, 81, 97, 255, 91, 102, 123, 255, 105, 118, 142, 255, 113, 127, 152, 240, 115, 129, 155, 204, 111, 124, 149, 196, 111, 125, 150, 255, 126, 141, 170, 234, 119, 133, 159, 120, 120, 134, 160, 116, 121, 135, 161, 117, 121, 135, 162, 119, 116, 130, 155, 152, 127, 142, 170, 255, 125, 140, 168, 248, 123, 138, 166, 199, 130, 145, 173, 235, 140, 155, 183, 255, 143, 160, 190, 255, 143, 161, 193, 255, 147, 165, 199, 255, 145, 164, 197, 255, 132, 148, 177, 230, 127, 140, 166, 126, 124, 134, 151, 12, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 138, 141, 144, 3, 55, 58, 63, 58, 37, 40, 46, 126, 34, 38, 44, 184, 34, 38, 44, 235, 35, 39, 47, 254, 49, 55, 66, 255, 64, 72, 87, 255, 77, 87, 104, 255, 88, 98, 118, 255, 96, 108, 130, 255, 103, 116, 139, 255, 108, 122, 147, 255, 113, 127, 153, 255, 118, 133, 160, 255, 124, 140, 168, 255, 133, 148, 176, 255, 141, 156, 183, 255, 146, 161, 187, 255, 144, 159, 186, 255, 131, 146, 174, 254, 127, 141, 168, 237, 126, 141, 168, 188, 123, 137, 162, 131, 112, 123, 143, 61, 128, 132, 140, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 91, 94, 98, 19, 64, 68, 73, 56, 53, 57, 65, 82, 62, 67, 76, 116, 66, 74, 89, 255, 95, 107, 129, 255, 80, 88, 103, 155, 81, 90, 105, 151, 86, 95, 112, 151, 95, 104, 122, 151, 98, 109, 128, 180, 124, 139, 166, 255, 109, 122, 146, 218, 100, 110, 128, 84, 96, 104, 118, 56, 105, 109, 117, 22, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 173, 174, 176, 2, 74, 83, 98, 252, 131, 147, 178, 255, 140, 155, 184, 29, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 122, 134, 157, 114, 151, 169, 203, 255, 123, 138, 165, 174, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 68, 76, 90, 224, 122, 137, 165, 255, 136, 152, 182, 69, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 125, 139, 165, 147, 146, 164, 198, 255, 122, 137, 165, 144, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62, 69, 81, 191, 110, 124, 149, 255, 134, 151, 181, 113, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 128, 143, 170, 193, 142, 160, 192, 255, 122, 137, 164, 111, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 58, 63, 74, 150, 94, 105, 127, 255, 133, 149, 179, 166, 0, 0, 0, 0, 0, 0, 0, 0, 115, 119, 128, 5, 130, 145, 174, 242, 137, 154, 186, 255, 125, 139, 166, 70, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 54, 58, 66, 102, 72, 81, 97, 255, 132, 148, 178, 236, 148, 161, 187, 5, 0, 0, 0, 0, 110, 121, 140, 64, 140, 157, 189, 255, 127, 142, 171, 254, 131, 144, 169, 23, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62, 65, 71, 43, 47, 52, 63, 255, 127, 143, 172, 255, 132, 148, 177, 75, 0, 0, 0, 0, 121, 134, 158, 160, 139, 156, 188, 255, 123, 138, 165, 223, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 154, 156, 158, 1, 36, 39, 46, 227, 106, 119, 143, 255, 130, 145, 175, 203, 114, 125, 147, 51, 123, 138, 166, 247, 131, 147, 177, 255, 123, 138, 165, 151, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 37, 41, 47, 143, 68, 77, 93, 255, 128, 144, 174, 255, 126, 141, 170, 252, 129, 145, 174, 255, 123, 138, 166, 255, 127, 141, 167, 68, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 65, 68, 73, 40, 34, 38, 46, 250, 117, 131, 158, 255, 126, 142, 171, 255, 124, 140, 168, 255, 125, 139, 166, 214, 140, 152, 172, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 41, 44, 50, 134, 58, 66, 79, 255, 123, 138, 166, 255, 123, 138, 166, 250, 127, 140, 165, 66, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 154, 156, 158, 1, 46, 50, 55, 83, 82, 89, 102, 123, 106, 116, 136, 51, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
        }; // zig fmt: on

        return try (ImageRgba.init(32, 32, image_data[0..])
            .setHandle("Tecgraf")
            .unwrap());
    }

    pub fn loadPrize() !*ImageRgb {
        const image_data_24 = [_]u8{ // zig fmt: off
            0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
            0,0,0,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,0,0,0,
            0,0,0,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,0,0,0,
            0,0,0,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,0,0,0,
            0,0,0,255,255,255,255,255,255,255,255,255,255,0,0,255,0,0,255,0,0,255,0,0,255,0,0,255,0,0,0,255,0,0,255,0,0,255,0,0,255,0,0,255,0,255,255,255,255,255,255,255,255,255,255,255,255,0,0,0, 
            0,0,0,255,255,255,255,255,255,255,255,255,255,0,0,255,0,0,255,0,0,255,0,0,255,0,0,255,0,0,0,255,0,0,255,0,0,255,0,0,255,0,0,255,0,255,255,255,255,255,255,255,255,255,255,255,255,0,0,0, 
            0,0,0,255,255,255,255,255,255,255,255,255,255,0,0,255,0,0,255,0,0,255,0,0,255,0,0,255,0,0,0,255,0,0,255,0,0,255,0,0,255,0,0,255,0,255,255,255,255,255,255,255,255,255,255,255,255,0,0,0, 
            0,0,0,255,255,255,255,255,255,255,255,255,255,0,0,255,0,0,255,0,0,255,0,0,255,0,0,255,0,0,0,255,0,0,255,0,0,255,0,0,255,0,0,255,0,255,255,255,255,255,255,255,255,255,255,255,255,0,0,0, 
            0,0,0,255,255,255,255,255,255,255,255,255,255,0,0,255,0,0,255,0,0,255,0,0,255,0,0,255,0,0,0,255,0,0,255,0,0,255,0,0,255,0,0,255,0,255,255,255,255,255,255,255,255,255,255,255,255,0,0,0, 
            0,0,0,255,255,255,255,255,255,255,255,255,255,0,0,255,0,0,255,0,0,255,0,0,255,0,0,255,0,0,0,255,0,0,255,0,0,255,0,0,255,0,0,255,0,255,255,255,255,255,255,255,255,255,255,255,255,0,0,0, 
            0,0,0,255,255,255,255,255,255,255,255,255,0,0,255,0,0,255,0,0,255,0,0,255,0,0,255,0,0,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,0,0,0, 
            0,0,0,255,255,255,255,255,255,255,255,255,0,0,255,0,0,255,0,0,255,0,0,255,0,0,255,0,0,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,0,0,0, 
            0,0,0,255,255,255,255,255,255,255,255,255,0,0,255,0,0,255,0,0,255,0,0,255,0,0,255,0,0,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,0,0,0, 
            0,0,0,255,255,255,255,255,255,255,255,255,0,0,255,0,0,255,0,0,255,0,0,255,0,0,255,0,0,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,0,0,0, 
            0,0,0,255,255,255,255,255,255,255,255,255,0,0,255,0,0,255,0,0,255,0,0,255,0,0,255,0,0,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,0,0,0, 
            0,0,0,255,255,255,255,255,255,255,255,255,0,0,255,0,0,255,0,0,255,0,0,255,0,0,255,0,0,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,0,0,0,
            0,0,0,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,0,0,0,
            0,0,0,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,0,0,0,
            0,0,0,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,0,0,0,
            0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
        }; // zig fmt: on

        return try (ImageRgb.init(20, 20, image_data_24[0..])
            .setHandle("IMG").unwrap());
    }

    pub fn loadGold() !*Image {
        const image_data = [_]u8{ // zig fmt: off;
            0, 0, 0, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 0, 0, 0,
            0, 0, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 0, 0,
            0, 0, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 0, 0,
            0, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 0,
            0, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 0,
            0, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 0,
            0, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 0,
            0, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 0,
            0, 3, 4, 4, 2, 4, 4, 4, 4, 4, 2, 2, 4, 4, 3, 0,
            2, 0, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 2,
            0, 0, 3, 3, 2, 2, 2, 1, 1, 2, 2, 2, 1, 3, 3, 0,
            0, 1, 1, 1, 3, 2, 1, 1, 1, 1, 2, 3, 3, 3, 3, 0,
            3, 3, 1, 1, 1, 3, 3, 3, 1, 3, 3, 1, 1, 1, 1, 1,
            3, 3, 1, 1, 1, 1, 1, 3, 3, 1, 1, 1, 1, 1, 1, 1,
            0, 0, 0, 0, 3, 1, 1, 0, 0, 1, 1, 1, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 3, 3, 0, 0, 1, 1, 3, 0, 0, 0, 0,
        }; //zig fmt: on

        return try (Image.init(16, 16, image_data[0..])
            .setColors(0, Rgb.BG_COLOR)
            .setColors(1, .{ .r = 128, .g = 0, .b = 0 })
            .setColors(2, .{ .r = 128, .g = 128, .b = 0 })
            .setColors(3, .{ .r = 255, .g = 0, .b = 0 })
            .setColors(4, .{ .r = 255, .g = 255, .b = 0 })
            .setHandle("IMGGOLD")
            .unwrap());
    }

    pub fn loadSilver() !*Image {
        const image_data = [_]u8{ // zig fmt: off;
            0, 0, 0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0, 0, 0,
            0, 0, 4, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 4, 0, 0,
            0, 0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0, 0,
            0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0,
            0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0,
            0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0,
            0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0,
            0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0,
            0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 3, 3, 3, 0,
            3, 0, 2, 2, 2, 2, 2, 3, 3, 2, 2, 2, 2, 2, 0, 3,
            0, 0, 1, 1, 2, 2, 1, 1, 1, 2, 2, 2, 1, 1, 3, 0,
            0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
            2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
            2, 1, 1, 1, 1, 1, 1, 1, 2, 1, 1, 1, 1, 1, 1, 1,
            0, 0, 0, 0, 2, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 1, 1, 0, 0, 1, 1, 2, 0, 0, 0, 0,
        }; //zig fmt: on

        return try (Image.init(16, 16, image_data[0..])
            .setColors(0, Rgb.BG_COLOR)
            .setColors(1, .{ .r = 0, .g = 128, .b = 128 })
            .setColors(2, .{ .r = 128, .g = 128, .b = 128 })
            .setColors(3, .{ .r = 192, .g = 192, .b = 192 })
            .setColors(4, .{ .r = 255, .g = 255, .b = 255 })
            .setHandle("IMGSILVER")
            .unwrap());
    }

    pub fn loadBronze() !*Image {
        const image_data = [_]u8{ // zig fmt: off;
            0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0,
            0, 0, 4, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 4, 0, 0,
            0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0,
            0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
            0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
            0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
            0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
            0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0,
            0, 1, 1, 1, 3, 3, 1, 1, 1, 1, 3, 3, 1, 1, 1, 0,
            4, 0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 0, 4,
            0, 0, 3, 3, 3, 3, 2, 2, 2, 2, 3, 2, 2, 3, 4, 0,
            0, 2, 2, 2, 2, 3, 2, 2, 2, 2, 2, 2, 2, 2, 3, 0,
            4, 3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3,
            4, 3, 2, 2, 2, 2, 2, 2, 4, 2, 2, 2, 2, 2, 2, 3,
            0, 0, 0, 0, 3, 2, 2, 0, 0, 2, 2, 2, 0, 0, 0, 0,
            0, 0, 0, 0, 0, 3, 3, 0, 0, 2, 2, 4, 0, 0, 0, 0,
        }; //zig fmt: on

        return try (Image.init(16, 16, image_data[0..])
            .setColors(0, Rgb.BG_COLOR)
            .setColors(1, .{ .r = 128, .g = 0, .b = 0 })
            .setColors(2, .{ .r = 0, .g = 128, .b = 0 })
            .setColors(3, .{ .r = 128, .g = 128, .b = 0 })
            .setColors(4, .{ .r = 128, .g = 128, .b = 128 })
            .setHandle("IMGBRONZE")
            .unwrap());
    }
};
