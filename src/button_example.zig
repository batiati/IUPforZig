/// From original example in C
/// https://webserver2.tecgraf.puc-rio.br/iup/examples/C/button.c
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
    var img_release = try images.getRelease();
    var img_press = try images.getPress();
    var img_inactive = try images.getInactive();

    return try (Dialog.init()
        .setTitle("IUPforZig - Buttons")
        .setMinBox(false)
        .setMaxBox(false)
        .setMenuBox(false)
        .setSize(.Quarter, .Quarter)
        .setResize(false)
        .setChildren(
        .{
            VBox.init()
                .setExpandChildren(true)
                .setMargin(10, 10)
                .setGap(10)
                .setChildren(
                .{
                    HBox.init().setChildren(
                        .{
                            Button.init()
                                .setTitle("Button with image")
                                .setName("btn_image")
                                .setCanFocus(false)
                                .setImPress(img_press.getHandleName())
                                .setImage(img_release.getHandleName())
                                .setIMinActive(img_inactive.getHandleName()) //wrong name!
                                .setButtonCallback(btn_image_button),
                            Button.init()
                                .setTitle("on/off")
                                .setActionCallback(btn_on_off_cb)
                                .setName("btn_onoff"),
                            Button.init()
                                .setTitle("Exit")
                                .setName("btn_exit")
                                .setActionCallback(btn_exit_cb),
                        },
                    ),
                    Text.init()
                        .setName("text")
                        .setReadonly(true),
                    Button.init()
                        .setTitle("Big useless button")
                        .setButtonCallback(btn_big_button_cb),
                },
            ),
        },
    )
        .unwrap());
}

fn btn_image_button(self: *Button, button: i32, pressed: i32, x: i32, y: i32, status: [:0]const u8) anyerror!void {
    std.debug.print("BUTTON_CB(button={}, press={})\n", .{ button, pressed });
    var text: *Text = self.getDialogChild("text").?.Text;
    if (button == '1') {
        if (pressed == 1) {
            text.setValue("Red button pressed");
        } else {
            text.setValue("Red button released");
        }
    }
}

fn btn_on_off_cb(button: *Button) anyerror!void {
    var btn_image: *Button = button.getDialogChild("btn_image").?.Button;

    var active = btn_image.getActive();
    btn_image.setActive(!active);
}

fn btn_exit_cb(button: *Button) anyerror!void {
    MainLoop.exitLoop();
}

fn btn_big_button_cb(self: *Button, button: i32, pressed: i32, x: i32, y: i32, status: [:0]const u8) anyerror!void {
    std.debug.print("BUTTON_CB(button={}, press={})\n", .{ button, pressed });
}

const images = struct {

    /// Defines button's image
    /// Each index corresponds to a RGB index from 1 to 4
    /// This image is a 16x16 matrix
    const pixelmap = [_]u8{ // zig fmt: off
       1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
       1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,
       1,1,3,3,3,3,3,3,3,3,3,3,3,3,2,2,
       1,1,3,3,3,3,3,3,3,3,3,3,3,3,2,2,
       1,1,3,3,3,3,3,3,3,3,3,3,3,3,2,2,
       1,1,3,3,3,3,3,3,3,3,3,3,3,3,2,2,
       1,1,3,3,3,3,3,3,3,3,3,3,3,3,2,2,
       1,1,3,3,3,3,3,3,4,4,3,3,3,3,2,2,
       1,1,3,3,3,3,3,4,4,4,4,3,3,3,2,2,
       1,1,3,3,3,3,3,4,4,4,4,3,3,3,2,2,
       1,1,3,3,3,3,3,3,4,4,3,3,3,3,2,2,
       1,1,3,3,3,3,3,3,3,3,3,3,3,3,2,2,
       1,1,3,3,3,3,3,3,3,3,3,3,3,3,2,2,
       1,1,3,3,3,3,3,3,3,3,3,3,3,3,2,2,
       1,1,3,3,3,3,3,3,3,3,3,3,3,3,2,2,
       1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,
       2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,        
     }; // zig fmt: on

    /// Defines pressed button's image
    pub fn getRelease() !*Image {
        return try (Image.init(16, 16, pixelmap[0..])
            .setHandleName("img_release")
            .setColors(1, .{ .r = 215, .g = 215, .b = 215 })
            .setColors(2, .{ .r = 40, .g = 40, .b = 40 })
            .setColors(3, .{ .r = 30, .g = 50, .b = 210 })
            .setColors(4, .{ .r = 240, .g = 0, .b = 0 })
            .unwrap());
    }

    pub fn getPress() !*Image {
        return try (Image.init(16, 16, pixelmap[0..])
            .setHandleName("img_press")
            .setColors(1, .{ .r = 40, .g = 40, .b = 40 })
            .setColors(2, .{ .r = 215, .g = 215, .b = 215 })
            .setColors(3, .{ .r = 0, .g = 20, .b = 180 })
            .setColors(4, .{ .r = 210, .g = 0, .b = 0 })
            .unwrap());
    }

    pub fn getInactive() !*Image {
        return try (Image.init(16, 16, pixelmap[0..])
            .setHandleName("img_inactive")
            .setColors(1, .{ .r = 215, .g = 215, .b = 215 })
            .setColors(2, .{ .r = 40, .g = 40, .b = 40 })
            .setColors(3, .{ .r = 100, .g = 100, .b = 100 })
            .setColors(4, .{ .r = 200, .g = 200, .b = 200 })
            .unwrap());
    }
};
