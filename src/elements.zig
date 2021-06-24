// This code was generated by a tool.
// IUP Metadata Code Generator
// https://github.com/batiati/IUPMetadata
//
//
// Changes to this file may cause incorrect behavior and will be lost if
// the code is regenerated.

const std = @import("std");
const ascii = std.ascii;
const testing = std.testing;

const Impl = @import("../impl.zig").Impl;
const CallbackHandler = @import("../callback_handler.zig").CallbackHandler;

const iup = @import("iup.zig");
const c = @import("c.zig");
const ChildrenIterator = iup.ChildrenIterator;

pub const Handle = c.Ihandle;
pub const Fill = @import("elements/fill.zig").Fill;
pub const DetachBox = @import("elements/detach_box.zig").DetachBox;
pub const Split = @import("elements/split.zig").Split;
pub const HBox = @import("elements/h_box.zig").HBox;
pub const Label = @import("elements/label.zig").Label;
pub const Tree = @import("elements/tree.zig").Tree;
pub const BackgroundBox = @import("elements/background_box.zig").BackgroundBox;
pub const Normalizer = @import("elements/normalizer.zig").Normalizer;
pub const FontDlg = @import("elements/font_dlg.zig").FontDlg;
pub const FlatList = @import("elements/flat_list.zig").FlatList;
pub const Thread = @import("elements/thread.zig").Thread;
pub const AnimatedLabel = @import("elements/animated_label.zig").AnimatedLabel;
pub const ColorDlg = @import("elements/color_dlg.zig").ColorDlg;
pub const Timer = @import("elements/timer.zig").Timer;
pub const VBox = @import("elements/v_box.zig").VBox;
pub const Tabs = @import("elements/tabs.zig").Tabs;
pub const Multiline = @import("elements/multiline.zig").Multiline;
pub const FlatFrame = @import("elements/flat_frame.zig").FlatFrame;
pub const Image = @import("elements/image.zig").Image;
pub const DropButton = @import("elements/drop_button.zig").DropButton;
pub const Space = @import("elements/space.zig").Space;
pub const FlatSeparator = @import("elements/flat_separator.zig").FlatSeparator;
pub const SBox = @import("elements/s_box.zig").SBox;
pub const FlatLabel = @import("elements/flat_label.zig").FlatLabel;
pub const Param = @import("elements/param.zig").Param;
pub const Button = @import("elements/button.zig").Button;
pub const FileDlg = @import("elements/file_dlg.zig").FileDlg;
pub const List = @import("elements/list.zig").List;
pub const ZBox = @import("elements/z_box.zig").ZBox;
pub const ScrollBox = @import("elements/scroll_box.zig").ScrollBox;
pub const DatePick = @import("elements/date_pick.zig").DatePick;
pub const Spin = @import("elements/spin.zig").Spin;
pub const Clipboard = @import("elements/clipboard.zig").Clipboard;
pub const SubMenu = @import("elements/sub_menu.zig").SubMenu;
pub const GridBox = @import("elements/grid_box.zig").GridBox;
pub const ImageRgba = @import("elements/image_rgba.zig").ImageRgba;
pub const Text = @import("elements/text.zig").Text;
pub const Radio = @import("elements/radio.zig").Radio;
pub const Gauge = @import("elements/gauge.zig").Gauge;
pub const ColorBar = @import("elements/color_bar.zig").ColorBar;
pub const ProgressDlg = @import("elements/progress_dlg.zig").ProgressDlg;
pub const Val = @import("elements/val.zig").Val;
pub const Dial = @import("elements/dial.zig").Dial;
pub const MultiBox = @import("elements/multi_box.zig").MultiBox;
pub const Expander = @import("elements/expander.zig").Expander;
pub const CBox = @import("elements/c_box.zig").CBox;
pub const Separator = @import("elements/separator.zig").Separator;
pub const Menu = @import("elements/menu.zig").Menu;
pub const FlatVal = @import("elements/flat_val.zig").FlatVal;
pub const FlatToggle = @import("elements/flat_toggle.zig").FlatToggle;
pub const Calendar = @import("elements/calendar.zig").Calendar;
pub const Item = @import("elements/item.zig").Item;
pub const ParamBox = @import("elements/param_box.zig").ParamBox;
pub const FlatButton = @import("elements/flat_button.zig").FlatButton;
pub const Canvas = @import("elements/canvas.zig").Canvas;
pub const Dialog = @import("elements/dialog.zig").Dialog;
pub const User = @import("elements/user.zig").User;
pub const ColorBrowser = @import("elements/color_browser.zig").ColorBrowser;
pub const Toggle = @import("elements/toggle.zig").Toggle;
pub const SpinBox = @import("elements/spin_box.zig").SpinBox;
pub const Link = @import("elements/link.zig").Link;
pub const ImageRgb = @import("elements/image_rgb.zig").ImageRgb;
pub const FlatTree = @import("elements/flat_tree.zig").FlatTree;
pub const ProgressBar = @import("elements/progress_bar.zig").ProgressBar;
pub const FlatScrollBox = @import("elements/flat_scroll_box.zig").FlatScrollBox;
pub const MessageDlg = @import("elements/message_dlg.zig").MessageDlg;
pub const Frame = @import("elements/frame.zig").Frame;
pub const FlatTabs = @import("elements/flat_tabs.zig").FlatTabs;

///
/// IUP contains several user interface elements.
/// The library’s main characteristic is the use of native elements.
/// This means that the drawing and management of a button or text box is done by the native interface system, not by IUP.
/// This makes the application’s appearance more similar to other applications in that system. On the other hand, the application’s appearance can vary from one system to another.
/// 
/// But this is valid only for the standard elements, many additional elements are drawn by IUP.
/// Composition elements are not visible, so they are independent from the native system.
/// 
/// Each element has an unique creation function, and all of its management is done by means of attributes and callbacks, using functions common to all the elements. This simple but powerful approach is one of the advantages of using IUP.
/// Elements are automatically destroyed when the dialog is destroyed.
pub const Element = union(enum) {
    Fill: *Fill,
    DetachBox: *DetachBox,
    Split: *Split,
    HBox: *HBox,
    Label: *Label,
    Tree: *Tree,
    BackgroundBox: *BackgroundBox,
    Normalizer: *Normalizer,
    FontDlg: *FontDlg,
    FlatList: *FlatList,
    Thread: *Thread,
    AnimatedLabel: *AnimatedLabel,
    ColorDlg: *ColorDlg,
    Timer: *Timer,
    VBox: *VBox,
    Tabs: *Tabs,
    Multiline: *Multiline,
    FlatFrame: *FlatFrame,
    Image: *Image,
    DropButton: *DropButton,
    Space: *Space,
    FlatSeparator: *FlatSeparator,
    SBox: *SBox,
    FlatLabel: *FlatLabel,
    Param: *Param,
    Button: *Button,
    FileDlg: *FileDlg,
    List: *List,
    ZBox: *ZBox,
    ScrollBox: *ScrollBox,
    DatePick: *DatePick,
    Spin: *Spin,
    Clipboard: *Clipboard,
    SubMenu: *SubMenu,
    GridBox: *GridBox,
    ImageRgba: *ImageRgba,
    Text: *Text,
    Radio: *Radio,
    Gauge: *Gauge,
    ColorBar: *ColorBar,
    ProgressDlg: *ProgressDlg,
    Val: *Val,
    Dial: *Dial,
    MultiBox: *MultiBox,
    Expander: *Expander,
    CBox: *CBox,
    Separator: *Separator,
    Menu: *Menu,
    FlatVal: *FlatVal,
    FlatToggle: *FlatToggle,
    Calendar: *Calendar,
    Item: *Item,
    ParamBox: *ParamBox,
    FlatButton: *FlatButton,
    Canvas: *Canvas,
    Dialog: *Dialog,
    User: *User,
    ColorBrowser: *ColorBrowser,
    Toggle: *Toggle,
    SpinBox: *SpinBox,
    Link: *Link,
    ImageRgb: *ImageRgb,
    FlatTree: *FlatTree,
    ProgressBar: *ProgressBar,
    FlatScrollBox: *FlatScrollBox,
    MessageDlg: *MessageDlg,
    Frame: *Frame,
    FlatTabs: *FlatTabs,

    Unknown: *Handle,

    pub fn fromType(comptime T: type, handle: anytype) Element {
        switch (T) {
            Fill, *Fill => return .{ .Fill = @ptrCast(*Fill, handle) },
            DetachBox, *DetachBox => return .{ .DetachBox = @ptrCast(*DetachBox, handle) },
            Split, *Split => return .{ .Split = @ptrCast(*Split, handle) },
            HBox, *HBox => return .{ .HBox = @ptrCast(*HBox, handle) },
            Label, *Label => return .{ .Label = @ptrCast(*Label, handle) },
            Tree, *Tree => return .{ .Tree = @ptrCast(*Tree, handle) },
            BackgroundBox, *BackgroundBox => return .{ .BackgroundBox = @ptrCast(*BackgroundBox, handle) },
            Normalizer, *Normalizer => return .{ .Normalizer = @ptrCast(*Normalizer, handle) },
            FontDlg, *FontDlg => return .{ .FontDlg = @ptrCast(*FontDlg, handle) },
            FlatList, *FlatList => return .{ .FlatList = @ptrCast(*FlatList, handle) },
            Thread, *Thread => return .{ .Thread = @ptrCast(*Thread, handle) },
            AnimatedLabel, *AnimatedLabel => return .{ .AnimatedLabel = @ptrCast(*AnimatedLabel, handle) },
            ColorDlg, *ColorDlg => return .{ .ColorDlg = @ptrCast(*ColorDlg, handle) },
            Timer, *Timer => return .{ .Timer = @ptrCast(*Timer, handle) },
            VBox, *VBox => return .{ .VBox = @ptrCast(*VBox, handle) },
            Tabs, *Tabs => return .{ .Tabs = @ptrCast(*Tabs, handle) },
            Multiline, *Multiline => return .{ .Multiline = @ptrCast(*Multiline, handle) },
            FlatFrame, *FlatFrame => return .{ .FlatFrame = @ptrCast(*FlatFrame, handle) },
            Image, *Image => return .{ .Image = @ptrCast(*Image, handle) },
            DropButton, *DropButton => return .{ .DropButton = @ptrCast(*DropButton, handle) },
            Space, *Space => return .{ .Space = @ptrCast(*Space, handle) },
            FlatSeparator, *FlatSeparator => return .{ .FlatSeparator = @ptrCast(*FlatSeparator, handle) },
            SBox, *SBox => return .{ .SBox = @ptrCast(*SBox, handle) },
            FlatLabel, *FlatLabel => return .{ .FlatLabel = @ptrCast(*FlatLabel, handle) },
            Param, *Param => return .{ .Param = @ptrCast(*Param, handle) },
            Button, *Button => return .{ .Button = @ptrCast(*Button, handle) },
            FileDlg, *FileDlg => return .{ .FileDlg = @ptrCast(*FileDlg, handle) },
            List, *List => return .{ .List = @ptrCast(*List, handle) },
            ZBox, *ZBox => return .{ .ZBox = @ptrCast(*ZBox, handle) },
            ScrollBox, *ScrollBox => return .{ .ScrollBox = @ptrCast(*ScrollBox, handle) },
            DatePick, *DatePick => return .{ .DatePick = @ptrCast(*DatePick, handle) },
            Spin, *Spin => return .{ .Spin = @ptrCast(*Spin, handle) },
            Clipboard, *Clipboard => return .{ .Clipboard = @ptrCast(*Clipboard, handle) },
            SubMenu, *SubMenu => return .{ .SubMenu = @ptrCast(*SubMenu, handle) },
            GridBox, *GridBox => return .{ .GridBox = @ptrCast(*GridBox, handle) },
            ImageRgba, *ImageRgba => return .{ .ImageRgba = @ptrCast(*ImageRgba, handle) },
            Text, *Text => return .{ .Text = @ptrCast(*Text, handle) },
            Radio, *Radio => return .{ .Radio = @ptrCast(*Radio, handle) },
            Gauge, *Gauge => return .{ .Gauge = @ptrCast(*Gauge, handle) },
            ColorBar, *ColorBar => return .{ .ColorBar = @ptrCast(*ColorBar, handle) },
            ProgressDlg, *ProgressDlg => return .{ .ProgressDlg = @ptrCast(*ProgressDlg, handle) },
            Val, *Val => return .{ .Val = @ptrCast(*Val, handle) },
            Dial, *Dial => return .{ .Dial = @ptrCast(*Dial, handle) },
            MultiBox, *MultiBox => return .{ .MultiBox = @ptrCast(*MultiBox, handle) },
            Expander, *Expander => return .{ .Expander = @ptrCast(*Expander, handle) },
            CBox, *CBox => return .{ .CBox = @ptrCast(*CBox, handle) },
            Separator, *Separator => return .{ .Separator = @ptrCast(*Separator, handle) },
            Menu, *Menu => return .{ .Menu = @ptrCast(*Menu, handle) },
            FlatVal, *FlatVal => return .{ .FlatVal = @ptrCast(*FlatVal, handle) },
            FlatToggle, *FlatToggle => return .{ .FlatToggle = @ptrCast(*FlatToggle, handle) },
            Calendar, *Calendar => return .{ .Calendar = @ptrCast(*Calendar, handle) },
            Item, *Item => return .{ .Item = @ptrCast(*Item, handle) },
            ParamBox, *ParamBox => return .{ .ParamBox = @ptrCast(*ParamBox, handle) },
            FlatButton, *FlatButton => return .{ .FlatButton = @ptrCast(*FlatButton, handle) },
            Canvas, *Canvas => return .{ .Canvas = @ptrCast(*Canvas, handle) },
            Dialog, *Dialog => return .{ .Dialog = @ptrCast(*Dialog, handle) },
            User, *User => return .{ .User = @ptrCast(*User, handle) },
            ColorBrowser, *ColorBrowser => return .{ .ColorBrowser = @ptrCast(*ColorBrowser, handle) },
            Toggle, *Toggle => return .{ .Toggle = @ptrCast(*Toggle, handle) },
            SpinBox, *SpinBox => return .{ .SpinBox = @ptrCast(*SpinBox, handle) },
            Link, *Link => return .{ .Link = @ptrCast(*Link, handle) },
            ImageRgb, *ImageRgb => return .{ .ImageRgb = @ptrCast(*ImageRgb, handle) },
            FlatTree, *FlatTree => return .{ .FlatTree = @ptrCast(*FlatTree, handle) },
            ProgressBar, *ProgressBar => return .{ .ProgressBar = @ptrCast(*ProgressBar, handle) },
            FlatScrollBox, *FlatScrollBox => return .{ .FlatScrollBox = @ptrCast(*FlatScrollBox, handle) },
            MessageDlg, *MessageDlg => return .{ .MessageDlg = @ptrCast(*MessageDlg, handle) },
            Frame, *Frame => return .{ .Frame = @ptrCast(*Frame, handle) },
            FlatTabs, *FlatTabs => return .{ .FlatTabs = @ptrCast(*FlatTabs, handle) },

            else => @compileError("Type " ++ @typeName(T) ++ " cannot be converted to a Element"),
        }
    }

    pub fn fromRef(reference: anytype) Element {
        const referenceType = @TypeOf(reference);
        const typeInfo = @typeInfo(referenceType);

        if (comptime typeInfo == .Pointer) {
            const childType = typeInfo.Pointer.child;
            switch (childType) {
                Fill => return .{ .Fill = reference },
                DetachBox => return .{ .DetachBox = reference },
                Split => return .{ .Split = reference },
                HBox => return .{ .HBox = reference },
                Label => return .{ .Label = reference },
                Tree => return .{ .Tree = reference },
                BackgroundBox => return .{ .BackgroundBox = reference },
                Normalizer => return .{ .Normalizer = reference },
                FontDlg => return .{ .FontDlg = reference },
                FlatList => return .{ .FlatList = reference },
                Thread => return .{ .Thread = reference },
                AnimatedLabel => return .{ .AnimatedLabel = reference },
                ColorDlg => return .{ .ColorDlg = reference },
                Timer => return .{ .Timer = reference },
                VBox => return .{ .VBox = reference },
                Tabs => return .{ .Tabs = reference },
                Multiline => return .{ .Multiline = reference },
                FlatFrame => return .{ .FlatFrame = reference },
                Image => return .{ .Image = reference },
                DropButton => return .{ .DropButton = reference },
                Space => return .{ .Space = reference },
                FlatSeparator => return .{ .FlatSeparator = reference },
                SBox => return .{ .SBox = reference },
                FlatLabel => return .{ .FlatLabel = reference },
                Param => return .{ .Param = reference },
                Button => return .{ .Button = reference },
                FileDlg => return .{ .FileDlg = reference },
                List => return .{ .List = reference },
                ZBox => return .{ .ZBox = reference },
                ScrollBox => return .{ .ScrollBox = reference },
                DatePick => return .{ .DatePick = reference },
                Spin => return .{ .Spin = reference },
                Clipboard => return .{ .Clipboard = reference },
                SubMenu => return .{ .SubMenu = reference },
                GridBox => return .{ .GridBox = reference },
                ImageRgba => return .{ .ImageRgba = reference },
                Text => return .{ .Text = reference },
                Radio => return .{ .Radio = reference },
                Gauge => return .{ .Gauge = reference },
                ColorBar => return .{ .ColorBar = reference },
                ProgressDlg => return .{ .ProgressDlg = reference },
                Val => return .{ .Val = reference },
                Dial => return .{ .Dial = reference },
                MultiBox => return .{ .MultiBox = reference },
                Expander => return .{ .Expander = reference },
                CBox => return .{ .CBox = reference },
                Separator => return .{ .Separator = reference },
                Menu => return .{ .Menu = reference },
                FlatVal => return .{ .FlatVal = reference },
                FlatToggle => return .{ .FlatToggle = reference },
                Calendar => return .{ .Calendar = reference },
                Item => return .{ .Item = reference },
                ParamBox => return .{ .ParamBox = reference },
                FlatButton => return .{ .FlatButton = reference },
                Canvas => return .{ .Canvas = reference },
                Dialog => return .{ .Dialog = reference },
                User => return .{ .User = reference },
                ColorBrowser => return .{ .ColorBrowser = reference },
                Toggle => return .{ .Toggle = reference },
                SpinBox => return .{ .SpinBox = reference },
                Link => return .{ .Link = reference },
                ImageRgb => return .{ .ImageRgb = reference },
                FlatTree => return .{ .FlatTree = reference },
                ProgressBar => return .{ .ProgressBar = reference },
                FlatScrollBox => return .{ .FlatScrollBox = reference },
                MessageDlg => return .{ .MessageDlg = reference },
                Frame => return .{ .Frame = reference },
                FlatTabs => return .{ .FlatTabs = reference },

                else => @compileError("Type " ++ @typeName(referenceType) ++ " cannot be converted to a Element"),
            }
        } else {
            @compileError("Reference to a element expected");
        }
    }

    pub fn fromClassName(className: []const u8, handle: anytype) Element {
        if (ascii.eqlIgnoreCase(className, Fill.CLASS_NAME)) return .{ .Fill = @ptrCast(*Fill, handle) };
        if (ascii.eqlIgnoreCase(className, DetachBox.CLASS_NAME)) return .{ .DetachBox = @ptrCast(*DetachBox, handle) };
        if (ascii.eqlIgnoreCase(className, Split.CLASS_NAME)) return .{ .Split = @ptrCast(*Split, handle) };
        if (ascii.eqlIgnoreCase(className, HBox.CLASS_NAME)) return .{ .HBox = @ptrCast(*HBox, handle) };
        if (ascii.eqlIgnoreCase(className, Label.CLASS_NAME)) return .{ .Label = @ptrCast(*Label, handle) };
        if (ascii.eqlIgnoreCase(className, Tree.CLASS_NAME)) return .{ .Tree = @ptrCast(*Tree, handle) };
        if (ascii.eqlIgnoreCase(className, BackgroundBox.CLASS_NAME)) return .{ .BackgroundBox = @ptrCast(*BackgroundBox, handle) };
        if (ascii.eqlIgnoreCase(className, Normalizer.CLASS_NAME)) return .{ .Normalizer = @ptrCast(*Normalizer, handle) };
        if (ascii.eqlIgnoreCase(className, FontDlg.CLASS_NAME)) return .{ .FontDlg = @ptrCast(*FontDlg, handle) };
        if (ascii.eqlIgnoreCase(className, FlatList.CLASS_NAME)) return .{ .FlatList = @ptrCast(*FlatList, handle) };
        if (ascii.eqlIgnoreCase(className, Thread.CLASS_NAME)) return .{ .Thread = @ptrCast(*Thread, handle) };
        if (ascii.eqlIgnoreCase(className, AnimatedLabel.CLASS_NAME)) return .{ .AnimatedLabel = @ptrCast(*AnimatedLabel, handle) };
        if (ascii.eqlIgnoreCase(className, ColorDlg.CLASS_NAME)) return .{ .ColorDlg = @ptrCast(*ColorDlg, handle) };
        if (ascii.eqlIgnoreCase(className, Timer.CLASS_NAME)) return .{ .Timer = @ptrCast(*Timer, handle) };
        if (ascii.eqlIgnoreCase(className, VBox.CLASS_NAME)) return .{ .VBox = @ptrCast(*VBox, handle) };
        if (ascii.eqlIgnoreCase(className, Tabs.CLASS_NAME)) return .{ .Tabs = @ptrCast(*Tabs, handle) };
        if (ascii.eqlIgnoreCase(className, Multiline.CLASS_NAME)) return .{ .Multiline = @ptrCast(*Multiline, handle) };
        if (ascii.eqlIgnoreCase(className, FlatFrame.CLASS_NAME)) return .{ .FlatFrame = @ptrCast(*FlatFrame, handle) };
        if (ascii.eqlIgnoreCase(className, Image.CLASS_NAME)) return .{ .Image = @ptrCast(*Image, handle) };
        if (ascii.eqlIgnoreCase(className, DropButton.CLASS_NAME)) return .{ .DropButton = @ptrCast(*DropButton, handle) };
        if (ascii.eqlIgnoreCase(className, Space.CLASS_NAME)) return .{ .Space = @ptrCast(*Space, handle) };
        if (ascii.eqlIgnoreCase(className, FlatSeparator.CLASS_NAME)) return .{ .FlatSeparator = @ptrCast(*FlatSeparator, handle) };
        if (ascii.eqlIgnoreCase(className, SBox.CLASS_NAME)) return .{ .SBox = @ptrCast(*SBox, handle) };
        if (ascii.eqlIgnoreCase(className, FlatLabel.CLASS_NAME)) return .{ .FlatLabel = @ptrCast(*FlatLabel, handle) };
        if (ascii.eqlIgnoreCase(className, Param.CLASS_NAME)) return .{ .Param = @ptrCast(*Param, handle) };
        if (ascii.eqlIgnoreCase(className, Button.CLASS_NAME)) return .{ .Button = @ptrCast(*Button, handle) };
        if (ascii.eqlIgnoreCase(className, FileDlg.CLASS_NAME)) return .{ .FileDlg = @ptrCast(*FileDlg, handle) };
        if (ascii.eqlIgnoreCase(className, List.CLASS_NAME)) return .{ .List = @ptrCast(*List, handle) };
        if (ascii.eqlIgnoreCase(className, ZBox.CLASS_NAME)) return .{ .ZBox = @ptrCast(*ZBox, handle) };
        if (ascii.eqlIgnoreCase(className, ScrollBox.CLASS_NAME)) return .{ .ScrollBox = @ptrCast(*ScrollBox, handle) };
        if (ascii.eqlIgnoreCase(className, DatePick.CLASS_NAME)) return .{ .DatePick = @ptrCast(*DatePick, handle) };
        if (ascii.eqlIgnoreCase(className, Spin.CLASS_NAME)) return .{ .Spin = @ptrCast(*Spin, handle) };
        if (ascii.eqlIgnoreCase(className, Clipboard.CLASS_NAME)) return .{ .Clipboard = @ptrCast(*Clipboard, handle) };
        if (ascii.eqlIgnoreCase(className, SubMenu.CLASS_NAME)) return .{ .SubMenu = @ptrCast(*SubMenu, handle) };
        if (ascii.eqlIgnoreCase(className, GridBox.CLASS_NAME)) return .{ .GridBox = @ptrCast(*GridBox, handle) };
        if (ascii.eqlIgnoreCase(className, ImageRgba.CLASS_NAME)) return .{ .ImageRgba = @ptrCast(*ImageRgba, handle) };
        if (ascii.eqlIgnoreCase(className, Text.CLASS_NAME)) return .{ .Text = @ptrCast(*Text, handle) };
        if (ascii.eqlIgnoreCase(className, Radio.CLASS_NAME)) return .{ .Radio = @ptrCast(*Radio, handle) };
        if (ascii.eqlIgnoreCase(className, Gauge.CLASS_NAME)) return .{ .Gauge = @ptrCast(*Gauge, handle) };
        if (ascii.eqlIgnoreCase(className, ColorBar.CLASS_NAME)) return .{ .ColorBar = @ptrCast(*ColorBar, handle) };
        if (ascii.eqlIgnoreCase(className, ProgressDlg.CLASS_NAME)) return .{ .ProgressDlg = @ptrCast(*ProgressDlg, handle) };
        if (ascii.eqlIgnoreCase(className, Val.CLASS_NAME)) return .{ .Val = @ptrCast(*Val, handle) };
        if (ascii.eqlIgnoreCase(className, Dial.CLASS_NAME)) return .{ .Dial = @ptrCast(*Dial, handle) };
        if (ascii.eqlIgnoreCase(className, MultiBox.CLASS_NAME)) return .{ .MultiBox = @ptrCast(*MultiBox, handle) };
        if (ascii.eqlIgnoreCase(className, Expander.CLASS_NAME)) return .{ .Expander = @ptrCast(*Expander, handle) };
        if (ascii.eqlIgnoreCase(className, CBox.CLASS_NAME)) return .{ .CBox = @ptrCast(*CBox, handle) };
        if (ascii.eqlIgnoreCase(className, Separator.CLASS_NAME)) return .{ .Separator = @ptrCast(*Separator, handle) };
        if (ascii.eqlIgnoreCase(className, Menu.CLASS_NAME)) return .{ .Menu = @ptrCast(*Menu, handle) };
        if (ascii.eqlIgnoreCase(className, FlatVal.CLASS_NAME)) return .{ .FlatVal = @ptrCast(*FlatVal, handle) };
        if (ascii.eqlIgnoreCase(className, FlatToggle.CLASS_NAME)) return .{ .FlatToggle = @ptrCast(*FlatToggle, handle) };
        if (ascii.eqlIgnoreCase(className, Calendar.CLASS_NAME)) return .{ .Calendar = @ptrCast(*Calendar, handle) };
        if (ascii.eqlIgnoreCase(className, Item.CLASS_NAME)) return .{ .Item = @ptrCast(*Item, handle) };
        if (ascii.eqlIgnoreCase(className, ParamBox.CLASS_NAME)) return .{ .ParamBox = @ptrCast(*ParamBox, handle) };
        if (ascii.eqlIgnoreCase(className, FlatButton.CLASS_NAME)) return .{ .FlatButton = @ptrCast(*FlatButton, handle) };
        if (ascii.eqlIgnoreCase(className, Canvas.CLASS_NAME)) return .{ .Canvas = @ptrCast(*Canvas, handle) };
        if (ascii.eqlIgnoreCase(className, Dialog.CLASS_NAME)) return .{ .Dialog = @ptrCast(*Dialog, handle) };
        if (ascii.eqlIgnoreCase(className, User.CLASS_NAME)) return .{ .User = @ptrCast(*User, handle) };
        if (ascii.eqlIgnoreCase(className, ColorBrowser.CLASS_NAME)) return .{ .ColorBrowser = @ptrCast(*ColorBrowser, handle) };
        if (ascii.eqlIgnoreCase(className, Toggle.CLASS_NAME)) return .{ .Toggle = @ptrCast(*Toggle, handle) };
        if (ascii.eqlIgnoreCase(className, SpinBox.CLASS_NAME)) return .{ .SpinBox = @ptrCast(*SpinBox, handle) };
        if (ascii.eqlIgnoreCase(className, Link.CLASS_NAME)) return .{ .Link = @ptrCast(*Link, handle) };
        if (ascii.eqlIgnoreCase(className, ImageRgb.CLASS_NAME)) return .{ .ImageRgb = @ptrCast(*ImageRgb, handle) };
        if (ascii.eqlIgnoreCase(className, FlatTree.CLASS_NAME)) return .{ .FlatTree = @ptrCast(*FlatTree, handle) };
        if (ascii.eqlIgnoreCase(className, ProgressBar.CLASS_NAME)) return .{ .ProgressBar = @ptrCast(*ProgressBar, handle) };
        if (ascii.eqlIgnoreCase(className, FlatScrollBox.CLASS_NAME)) return .{ .FlatScrollBox = @ptrCast(*FlatScrollBox, handle) };
        if (ascii.eqlIgnoreCase(className, MessageDlg.CLASS_NAME)) return .{ .MessageDlg = @ptrCast(*MessageDlg, handle) };
        if (ascii.eqlIgnoreCase(className, Frame.CLASS_NAME)) return .{ .Frame = @ptrCast(*Frame, handle) };
        if (ascii.eqlIgnoreCase(className, FlatTabs.CLASS_NAME)) return .{ .FlatTabs = @ptrCast(*FlatTabs, handle) };

        return .{ .Unknown = @ptrCast(*Handle, handle) };
    }

    pub fn getHandle(self: Element) *Handle {
        switch (self) {
            .Fill => |value| return @ptrCast(*Handle, value),
            .DetachBox => |value| return @ptrCast(*Handle, value),
            .Split => |value| return @ptrCast(*Handle, value),
            .HBox => |value| return @ptrCast(*Handle, value),
            .Label => |value| return @ptrCast(*Handle, value),
            .Tree => |value| return @ptrCast(*Handle, value),
            .BackgroundBox => |value| return @ptrCast(*Handle, value),
            .Normalizer => |value| return @ptrCast(*Handle, value),
            .FontDlg => |value| return @ptrCast(*Handle, value),
            .FlatList => |value| return @ptrCast(*Handle, value),
            .Thread => |value| return @ptrCast(*Handle, value),
            .AnimatedLabel => |value| return @ptrCast(*Handle, value),
            .ColorDlg => |value| return @ptrCast(*Handle, value),
            .Timer => |value| return @ptrCast(*Handle, value),
            .VBox => |value| return @ptrCast(*Handle, value),
            .Tabs => |value| return @ptrCast(*Handle, value),
            .Multiline => |value| return @ptrCast(*Handle, value),
            .FlatFrame => |value| return @ptrCast(*Handle, value),
            .Image => |value| return @ptrCast(*Handle, value),
            .DropButton => |value| return @ptrCast(*Handle, value),
            .Space => |value| return @ptrCast(*Handle, value),
            .FlatSeparator => |value| return @ptrCast(*Handle, value),
            .SBox => |value| return @ptrCast(*Handle, value),
            .FlatLabel => |value| return @ptrCast(*Handle, value),
            .Param => |value| return @ptrCast(*Handle, value),
            .Button => |value| return @ptrCast(*Handle, value),
            .FileDlg => |value| return @ptrCast(*Handle, value),
            .List => |value| return @ptrCast(*Handle, value),
            .ZBox => |value| return @ptrCast(*Handle, value),
            .ScrollBox => |value| return @ptrCast(*Handle, value),
            .DatePick => |value| return @ptrCast(*Handle, value),
            .Spin => |value| return @ptrCast(*Handle, value),
            .Clipboard => |value| return @ptrCast(*Handle, value),
            .SubMenu => |value| return @ptrCast(*Handle, value),
            .GridBox => |value| return @ptrCast(*Handle, value),
            .ImageRgba => |value| return @ptrCast(*Handle, value),
            .Text => |value| return @ptrCast(*Handle, value),
            .Radio => |value| return @ptrCast(*Handle, value),
            .Gauge => |value| return @ptrCast(*Handle, value),
            .ColorBar => |value| return @ptrCast(*Handle, value),
            .ProgressDlg => |value| return @ptrCast(*Handle, value),
            .Val => |value| return @ptrCast(*Handle, value),
            .Dial => |value| return @ptrCast(*Handle, value),
            .MultiBox => |value| return @ptrCast(*Handle, value),
            .Expander => |value| return @ptrCast(*Handle, value),
            .CBox => |value| return @ptrCast(*Handle, value),
            .Separator => |value| return @ptrCast(*Handle, value),
            .Menu => |value| return @ptrCast(*Handle, value),
            .FlatVal => |value| return @ptrCast(*Handle, value),
            .FlatToggle => |value| return @ptrCast(*Handle, value),
            .Calendar => |value| return @ptrCast(*Handle, value),
            .Item => |value| return @ptrCast(*Handle, value),
            .ParamBox => |value| return @ptrCast(*Handle, value),
            .FlatButton => |value| return @ptrCast(*Handle, value),
            .Canvas => |value| return @ptrCast(*Handle, value),
            .Dialog => |value| return @ptrCast(*Handle, value),
            .User => |value| return @ptrCast(*Handle, value),
            .ColorBrowser => |value| return @ptrCast(*Handle, value),
            .Toggle => |value| return @ptrCast(*Handle, value),
            .SpinBox => |value| return @ptrCast(*Handle, value),
            .Link => |value| return @ptrCast(*Handle, value),
            .ImageRgb => |value| return @ptrCast(*Handle, value),
            .FlatTree => |value| return @ptrCast(*Handle, value),
            .ProgressBar => |value| return @ptrCast(*Handle, value),
            .FlatScrollBox => |value| return @ptrCast(*Handle, value),
            .MessageDlg => |value| return @ptrCast(*Handle, value),
            .Frame => |value| return @ptrCast(*Handle, value),
            .FlatTabs => |value| return @ptrCast(*Handle, value),

            .Unknown => |value| return @ptrCast(*Handle, value),
        }
    }

    pub fn children(self: Element) ChildrenIterator {
        switch (self) {
            .DetachBox => |value| return value.children(),
            .Split => |value| return value.children(),
            .HBox => |value| return value.children(),
            .BackgroundBox => |value| return value.children(),
            .VBox => |value| return value.children(),
            .Tabs => |value| return value.children(),
            .FlatFrame => |value| return value.children(),
            .SBox => |value| return value.children(),
            .ZBox => |value| return value.children(),
            .ScrollBox => |value| return value.children(),
            .SubMenu => |value| return value.children(),
            .GridBox => |value| return value.children(),
            .Radio => |value| return value.children(),
            .MultiBox => |value| return value.children(),
            .Expander => |value| return value.children(),
            .CBox => |value| return value.children(),
            .Menu => |value| return value.children(),
            .ParamBox => |value| return value.children(),
            .Dialog => |value| return value.children(),
            .User => |value| return value.children(),
            .SpinBox => |value| return value.children(),
            .FlatScrollBox => |value| return value.children(),
            .Frame => |value| return value.children(),
            .FlatTabs => |value| return value.children(),

            else => return ChildrenIterator.NoChildren,
        }
    }

    pub fn eql(self: Element, other: Element) bool {
        return @ptrToInt(self.getHandle()) == @ptrToInt(other.getHandle());
    }

    pub fn deinit(self: Element) void {
        switch (self) {
            .Fill => |element| element.deinit(),
            .DetachBox => |element| element.deinit(),
            .Split => |element| element.deinit(),
            .HBox => |element| element.deinit(),
            .Label => |element| element.deinit(),
            .Tree => |element| element.deinit(),
            .BackgroundBox => |element| element.deinit(),
            .Normalizer => |element| element.deinit(),
            .FontDlg => |element| element.deinit(),
            .FlatList => |element| element.deinit(),
            .Thread => |element| element.deinit(),
            .AnimatedLabel => |element| element.deinit(),
            .ColorDlg => |element| element.deinit(),
            .Timer => |element| element.deinit(),
            .VBox => |element| element.deinit(),
            .Tabs => |element| element.deinit(),
            .Multiline => |element| element.deinit(),
            .FlatFrame => |element| element.deinit(),
            .Image => |element| element.deinit(),
            .DropButton => |element| element.deinit(),
            .Space => |element| element.deinit(),
            .FlatSeparator => |element| element.deinit(),
            .SBox => |element| element.deinit(),
            .FlatLabel => |element| element.deinit(),
            .Param => |element| element.deinit(),
            .Button => |element| element.deinit(),
            .FileDlg => |element| element.deinit(),
            .List => |element| element.deinit(),
            .ZBox => |element| element.deinit(),
            .ScrollBox => |element| element.deinit(),
            .DatePick => |element| element.deinit(),
            .Spin => |element| element.deinit(),
            .Clipboard => |element| element.deinit(),
            .SubMenu => |element| element.deinit(),
            .GridBox => |element| element.deinit(),
            .ImageRgba => |element| element.deinit(),
            .Text => |element| element.deinit(),
            .Radio => |element| element.deinit(),
            .Gauge => |element| element.deinit(),
            .ColorBar => |element| element.deinit(),
            .ProgressDlg => |element| element.deinit(),
            .Val => |element| element.deinit(),
            .Dial => |element| element.deinit(),
            .MultiBox => |element| element.deinit(),
            .Expander => |element| element.deinit(),
            .CBox => |element| element.deinit(),
            .Separator => |element| element.deinit(),
            .Menu => |element| element.deinit(),
            .FlatVal => |element| element.deinit(),
            .FlatToggle => |element| element.deinit(),
            .Calendar => |element| element.deinit(),
            .Item => |element| element.deinit(),
            .ParamBox => |element| element.deinit(),
            .FlatButton => |element| element.deinit(),
            .Canvas => |element| element.deinit(),
            .Dialog => |element| element.deinit(),
            .User => |element| element.deinit(),
            .ColorBrowser => |element| element.deinit(),
            .Toggle => |element| element.deinit(),
            .SpinBox => |element| element.deinit(),
            .Link => |element| element.deinit(),
            .ImageRgb => |element| element.deinit(),
            .FlatTree => |element| element.deinit(),
            .ProgressBar => |element| element.deinit(),
            .FlatScrollBox => |element| element.deinit(),
            .MessageDlg => |element| element.deinit(),
            .Frame => |element| element.deinit(),
            .FlatTabs => |element| element.deinit(),

            else => unreachable,
        }
    }

    pub fn setAttribute(self: Element, attribute: [:0]const u8, value: [:0]const u8) void {
        c.setStrAttribute(self.getHandle(), attribute, .{}, value);
    }

    pub fn getAttribute(self: Element, attribute: [:0]const u8) [:0]const u8 {
        return c.getStrAttribute(self.getHandle(), attribute, .{});
    }

    pub fn setTag(self: Element, comptime T: type, attribute: [:0]const u8, value: ?*T) void {
        c.setPtrAttribute(T, self.getHandle(), attribute, .{}, value);
    }

    pub fn getTag(self: Element, comptime T: type, attribute: [:0]const u8) ?*T {
        return c.getPtrAttribute(T, self.getHandle(), attribute, .{});
    }
};

test "retrieve element fromType" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var handle = try iup.Label.init().unwrap();
    defer handle.deinit();

    var fromType = Element.fromType(iup.Label, handle);
    try testing.expect(fromType == .Label);
    try testing.expect(@ptrToInt(fromType.Label) == @ptrToInt(handle));
}

test "retrieve element fromRef" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var handle = try iup.Label.init().unwrap();
    defer handle.deinit();

    var fromRef = Element.fromRef(handle);
    try testing.expect(fromRef == .Label);
    try testing.expect(@ptrToInt(fromRef.Label) == @ptrToInt(handle));
}

test "retrieve element fromClassName" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var handle = try iup.Label.init().unwrap();
    defer handle.deinit();

    var fromClassName = Element.fromClassName(Label.CLASS_NAME, handle);
    try testing.expect(fromClassName == .Label);
    try testing.expect(@ptrToInt(fromClassName.Label) == @ptrToInt(handle));
}

test "getHandle" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var handle = try iup.Label.init().unwrap();
    defer handle.deinit();

    var element = Element{ .Label = handle };
    var value = element.getHandle();
    try testing.expect(@ptrToInt(handle) == @ptrToInt(value));
}

test "children" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var parent = try iup.HBox.init().unwrap();
    var child1 = try iup.HBox.init().unwrap();
    var child2 = try iup.HBox.init().unwrap();

    try parent.appendChild(child1);
    try parent.appendChild(child2);

    var element = Element{ .HBox = parent };
    var children = element.children();

    if (children.next()) |ret1| {
        try testing.expect(ret1 == .HBox);
        try testing.expect(ret1.HBox == child1);
    } else {
        try testing.expect(false);
    }

    if (children.next()) |ret2| {
        try testing.expect(ret2 == .HBox);
        try testing.expect(ret2.HBox == child2);
    } else {
        try testing.expect(false);
    }

    var ret3 = children.next();
    try testing.expect(ret3 == null);
}

test "eql" {
    try iup.MainLoop.open();
    defer iup.MainLoop.close();

    var l1 = Element.fromRef(try iup.Label.init().unwrap());
    defer l1.deinit();

    var l2 = Element.fromRef(try iup.Label.init().unwrap());
    defer l2.deinit();

    var l1_copy = l1;

    try testing.expect(l1.eql(l1));
    try testing.expect(l2.eql(l2));
    try testing.expect(l1.eql(l1_copy));
    try testing.expect(!l1.eql(l2));
    try testing.expect(!l2.eql(l1));
}
