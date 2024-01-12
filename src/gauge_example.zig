/// From original example in C
/// https://tecgraf.puc-rio.br/iup/examples/C/gauge.c
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
const Canvas = iup.Canvas;
const ScreenSize = iup.ScreenSize;
const Image = iup.Image;
const ImageRgb = iup.ImageRgb;
const ImageRgba = iup.ImageRgba;
const Rgb = iup.Rgb;
const Gauge = iup.Gauge;

const DEFAULT_SPEED: f64 = 0.00001;
var speed = DEFAULT_SPEED;

pub fn main() !void {
    try MainLoop.open();
    defer MainLoop.close();

    MainLoop.setIdleCallback(onIdle);

    var dlg = try createDialog();
    defer dlg.deinit();

    try dlg.showXY(.Center, .Center);

    try MainLoop.beginLoop();
}

fn createDialog() !*Dialog {
    var img_pause = try images.getPause();
    var img_forward = try images.getForward();
    var img_rewind = try images.getRewind();
    var img_show = try images.getShow();

    return try (Dialog.init()
        .setSize(ScreenSize{ .Size = 200 }, null)
        .setTitle("IupGauge")
        .setChildren(
        .{
            VBox.init()
                .setMargin(10, 10)
                .setGap(5)
                .setChildren(
                .{
                    Gauge.init()
                        .setHandle("gauge")
                        .setExpand(.Yes),
                    HBox.init()
                        .setChildren(
                        .{
                            Fill.init(),
                            Button.init().setActionCallback(onPause)
                                .setImage(img_pause)
                                .setTip("Pause"),
                            Button.init()
                                .setActionCallback(onRewind)
                                .setImage(img_rewind)
                                .setTip("Rewind"),
                            Button.init()
                                .setActionCallback(onForward)
                                .setImage(img_forward)
                                .setTip("Forward"),
                            Button.init()
                                .setActionCallback(onShow)
                                .setImage(img_show)
                                .setTip("Show"),
                            Fill.init(),
                        },
                    ),
                },
            ),
        },
    )
        .unwrap());
}

fn onPause(self: *Button) anyerror!void {
    if (speed == 0) {
        speed = DEFAULT_SPEED;
        var img = try images.getPause();
        try self.setImage(img);
    } else {
        speed = 0;
        var img = try images.getPlay();
        try self.setImage(img);
    }
}

fn onRewind(self: *Button) anyerror!void {
    _ = self;
    if (speed < 0) {
        speed *= 2;
    } else {
        speed = -1 * DEFAULT_SPEED;
    }
}

fn onForward(self: *Button) anyerror!void {
    _ = self;
    if (speed > 0) {
        speed *= 2;
    } else {
        speed = DEFAULT_SPEED;
    }
}

fn onShow(self: *Button) anyerror!void {
    _ = self;
    var gauge = Gauge.fromHandleName("gauge") orelse return;
    if (gauge.getShowText()) {
        gauge.setShowText(false);
        gauge.setDashed(true);
    } else {
        gauge.setShowText(true);
        gauge.setDashed(false);
    }
}

fn onIdle() anyerror!void {
    if (speed == 0) return;

    var gauge = Gauge.fromHandleName("gauge") orelse return;
    var value = gauge.getValue();

    value += speed;
    if (value > gauge.getMax()) {
        value = gauge.getMin();
    } else if (value < gauge.getMin()) {
        value = gauge.getMax();
    }

    gauge.setValue(value);
}

const images = struct {
    const pixmap_play = [_]u8{ // zig fmt: off
         2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2
        ,2,2,2,2,2,2,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2    
    }; // zig fmt: on

    const pixmap_pause = [_]u8{ // zig fmt: off
         2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,1,1,2,2,1,1,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,1,1,2,2,1,1,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,1,1,2,2,1,1,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,1,1,2,2,1,1,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,1,1,2,2,1,1,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,1,1,2,2,1,1,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,1,1,2,2,1,1,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,1,1,2,2,1,1,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,1,1,2,2,1,1,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2    
    }; // zig fmt: on

    const pixmap_rewind = [_]u8{ // zig fmt: off
         2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,1,2,2,2,2,1,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,1,1,2,2,2,1,1,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,1,1,1,2,2,1,1,1,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,1,1,1,1,2,1,1,1,1,2,2,2,2,2,2,2
        ,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,1,1,1,1,2,1,1,1,1,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,1,1,1,2,2,1,1,1,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,1,1,2,2,2,1,1,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,1,2,2,2,2,1,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2    
    }; // zig fmt: on

    const pixmap_forward = [_]u8{ // zig fmt: off
         2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,1,2,2,2,2,1,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,1,1,2,2,2,1,1,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,1,1,1,2,2,1,1,1,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,1,1,1,1,2,1,1,1,1,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2
        ,2,2,2,2,2,2,2,1,1,1,1,2,1,1,1,1,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,1,1,1,2,2,1,1,1,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,1,1,2,2,2,1,1,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,1,2,2,2,2,1,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2 
    }; // zig fmt: on

    const pixmap_show = [_]u8{ // zig fmt: off
         2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,1,1,1,1,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,1,1,2,2,2,2,1,1,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,1,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2
        ,2,2,2,2,2,1,2,2,2,1,1,1,2,2,2,2,1,2,2,2,2,2
        ,2,2,2,2,1,2,2,2,1,1,2,2,1,2,2,2,2,1,2,2,2,2
        ,2,2,2,1,2,2,2,2,1,1,1,2,1,2,2,2,2,2,1,2,2,2
        ,2,2,2,2,1,2,2,2,1,1,1,1,1,2,2,2,2,1,2,2,2,2
        ,2,2,2,2,2,1,2,2,2,1,1,1,2,2,2,2,1,2,2,2,2,2
        ,2,2,2,2,2,2,1,2,2,2,2,2,2,2,2,1,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,1,1,2,2,2,2,1,1,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,1,1,1,1,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2
        ,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2 
    }; // zig fmt: on

    pub fn getPause() !*Image {
        if (Image.fromHandleName("img_pause")) |value| return value;

        return try (Image.init(22, 22, pixmap_pause[0..])
            .setHandle("img_pause")
            .setColors(1, .{ .r = 0, .g = 0, .b = 0 })
            .setColors(2, Rgb.BG_COLOR)
            .unwrap());
    }

    pub fn getPlay() !*Image {
        if (Image.fromHandleName("img_play")) |value| return value;

        return try (Image.init(22, 22, pixmap_play[0..])
            .setHandle("img_play")
            .setColors(1, .{ .r = 0, .g = 0, .b = 0 })
            .setColors(2, Rgb.BG_COLOR)
            .unwrap());
    }

    pub fn getForward() !*Image {
        if (Image.fromHandleName("img_forward")) |value| return value;

        return try (Image.init(22, 22, pixmap_forward[0..])
            .setHandle("img_forward")
            .setColors(1, .{ .r = 0, .g = 0, .b = 0 })
            .setColors(2, Rgb.BG_COLOR)
            .unwrap());
    }

    pub fn getRewind() !*Image {
        if (Image.fromHandleName("img_rewind")) |value| return value;

        return try (Image.init(22, 22, pixmap_rewind[0..])
            .setHandle("img_rewind")
            .setColors(1, .{ .r = 0, .g = 0, .b = 0 })
            .setColors(2, Rgb.BG_COLOR)
            .unwrap());
    }

    pub fn getShow() !*Image {
        if (Image.fromHandleName("img_show")) |value| return value;

        return try (Image.init(22, 22, pixmap_show[0..])
            .setHandle("img_show")
            .setColors(1, .{ .r = 0, .g = 0, .b = 0 })
            .setColors(2, Rgb.BG_COLOR)
            .unwrap());
    }
};
