// This code was generated by a tool.
// IUP Metadata Code Generator
// https://github.com/batiati/IUPMetadata
//
//
// Changes to this file may cause incorrect behavior and will be lost if
// the code is regenerated.

const std = @import("std");

const interop = @import("../interop.zig");
const iup = @import("../iup.zig");

const Impl = @import("../impl.zig").Impl;
const CallbackHandler = @import("../callback_handler.zig").CallbackHandler;

const debug = std.debug;
const trait = std.meta.trait;

const Element = iup.Element;
const Handle = iup.Handle;
const Error = iup.Error;
const ChildrenIterator = iup.ChildrenIterator;
const Size = iup.Size;
const Margin = iup.Margin;

///
/// Construction element used only in IupParamBox.
/// It is not mapped in the native system, but it will exist while its
/// IupParamBox container exists.
pub const Param = opaque {
    pub const CLASS_NAME = "param";
    pub const NATIVE_TYPE = iup.NativeType.Void;
    const Self = @This();

    pub const OnLDestroyFn = fn (self: *Self) anyerror!void;

    ///
    /// DESTROY_CB DESTROY_CB Called right before an element is destroyed.
    /// Callback int function(Ihandle *ih); [in C] ih:destroy_cb() -> (ret: number)
    /// [in Lua] ih: identifier of the element that activated the event.
    /// Notes If the dialog is visible then it is hidden before it is destroyed.
    /// The callback will be called right after it is hidden.
    /// The callback will be called before all other destroy procedures.
    /// For instance, if the element has children then it is called before the
    /// children are destroyed.
    /// For language binding implementations use the callback name "LDESTROY_CB" to
    /// release memory allocated by the binding for the element.
    /// Also the callback will be called before the language callback.
    /// Affects All.
    pub const OnDestroyFn = fn (self: *Self) anyerror!void;

    ///
    /// MAP_CB MAP_CB Called right after an element is mapped and its attributes
    /// updated in IupMap.
    /// When the element is a dialog, it is called after the layout is updated.
    /// For all other elements is called before the layout is updated, so the
    /// element current size will still be 0x0 during MAP_CB (since 3.14).
    /// Callback int function(Ihandle *ih); [in C] ih:map_cb() -> (ret: number) [in
    /// Lua] ih: identifier of the element that activated the event.
    /// Affects All that have a native representation.
    pub const OnMapFn = fn (self: *Self) anyerror!void;

    pub const OnPostMessageFn = fn (self: *Self, arg0: [:0]const u8, arg1: i32, arg2: f64, arg3: ?*anyopaque) anyerror!void;

    ///
    /// UNMAP_CB UNMAP_CB Called right before an element is unmapped.
    /// Callback int function(Ihandle *ih); [in C] ih:unmap_cb() -> (ret: number)
    /// [in Lua] ih: identifier of the element that activated the event.
    /// Affects All that have a native representation.
    pub const OnUnmapFn = fn (self: *Self) anyerror!void;

    ///
    /// DIALOGTYPE, FILTER, DIRECTORY, NOCHANGEDIR, NOOVERWRITEPROMPT: used for the
    /// FILE parameter dialog.
    /// See IupFileDlg.
    /// For 'f' parameter.
    pub const DialogType = enum {
        Save,
        Dir,
        Open,
    };
    ///
    /// FLOATING (non inheritable) (at children only): If a child has FLOATING=YES
    /// then its size and position will be ignored by the layout processing.
    /// Default: "NO".
    /// (since 3.0)
    pub const Floating = enum {
        Yes,
        Ignore,
        No,
    };

    pub const Initializer = struct {
        last_error: ?anyerror = null,
        ref: *Self,

        ///
        /// Returns a pointer to IUP element or an error.
        /// Only top-level or detached elements needs to be unwraped,
        pub fn unwrap(self: Initializer) !*Self {
            if (self.last_error) |e| {
                return e;
            } else {
                return self.ref;
            }
        }

        ///
        /// Captures a reference into a external variable
        /// Allows to capture some references even using full declarative API
        pub fn capture(self: Initializer, ref: **Self) Initializer {
            ref.* = self.ref;
            return self;
        }

        pub fn setStrAttribute(self: Initializer, attributeName: [:0]const u8, arg: [:0]const u8) Initializer {
            if (self.last_error) |_| return self;
            Self.setStrAttribute(self.ref, attributeName, arg);
            return self;
        }

        pub fn setIntAttribute(self: Initializer, attributeName: [:0]const u8, arg: i32) Initializer {
            if (self.last_error) |_| return self;
            Self.setIntAttribute(self.ref, attributeName, arg);
            return self;
        }

        pub fn setBoolAttribute(self: Initializer, attributeName: [:0]const u8, arg: bool) Initializer {
            if (self.last_error) |_| return self;
            Self.setBoolAttribute(self.ref, attributeName, arg);
            return self;
        }

        pub fn setPtrAttribute(self: Initializer, comptime T: type, attributeName: [:0]const u8, value: ?*T) Initializer {
            if (self.last_error) |_| return self;
            Self.setPtrAttribute(self.ref, T, attributeName, value);
            return self;
        }

        pub fn setHandle(self: Initializer, arg: [:0]const u8) Initializer {
            if (self.last_error) |_| return self;
            interop.setHandle(self.ref, arg);
            return self;
        }

        pub fn setDirectory(self: Initializer, arg: [:0]const u8) Initializer {
            if (self.last_error) |_| return self;
            interop.setStrAttribute(self.ref, "DIRECTORY", .{}, arg);
            return self;
        }

        pub fn setNoOverwritePrompt(self: Initializer, arg: bool) Initializer {
            if (self.last_error) |_| return self;
            interop.setBoolAttribute(self.ref, "NOOVERWRITEPROMPT", .{}, arg);
            return self;
        }

        ///
        /// TITLE: text of the parameter, used as label.
        /// For all parameters.
        pub fn setTitle(self: Initializer, arg: [:0]const u8) Initializer {
            if (self.last_error) |_| return self;
            interop.setStrAttribute(self.ref, "TITLE", .{}, arg);
            return self;
        }

        ///
        /// MULTILINE: can be Yes or No.
        /// Defines if the edit box can have more than one line.
        /// For 'm' parameter.
        pub fn setMultiline(self: Initializer, arg: bool) Initializer {
            if (self.last_error) |_| return self;
            interop.setBoolAttribute(self.ref, "MULTILINE", .{}, arg);
            return self;
        }

        pub fn setFilter(self: Initializer, arg: [:0]const u8) Initializer {
            if (self.last_error) |_| return self;
            interop.setStrAttribute(self.ref, "FILTER", .{}, arg);
            return self;
        }

        ///
        /// TIP: text of the tip.
        /// For all parameters.
        pub fn setTip(self: Initializer, arg: [:0]const u8) Initializer {
            if (self.last_error) |_| return self;
            interop.setStrAttribute(self.ref, "TIP", .{}, arg);
            return self;
        }

        pub fn setMax(self: Initializer, arg: f64) Initializer {
            if (self.last_error) |_| return self;
            interop.setDoubleAttribute(self.ref, "MAX", .{}, arg);
            return self;
        }

        ///
        /// BUTTON1, BUTTON2, BUTTON3: button titles.
        /// Default is "OK/Cancel/Help" for regular IupGetParam, and "Apply/Reset/Help"
        /// when IupParamBox is directly used.
        /// For 'u' parameter.
        pub fn setButton1(self: Initializer, arg: [:0]const u8) Initializer {
            if (self.last_error) |_| return self;
            interop.setStrAttribute(self.ref, "BUTTON1", .{}, arg);
            return self;
        }

        pub fn setButton2(self: Initializer, arg: [:0]const u8) Initializer {
            if (self.last_error) |_| return self;
            interop.setStrAttribute(self.ref, "BUTTON2", .{}, arg);
            return self;
        }

        ///
        /// MASK: mask for the edit box input.
        /// For 's' and 'm' parameters.
        pub fn setMask(self: Initializer, arg: [:0]const u8) Initializer {
            if (self.last_error) |_| return self;
            interop.setStrAttribute(self.ref, "MASK", .{}, arg);
            return self;
        }

        pub fn setButton3(self: Initializer, arg: [:0]const u8) Initializer {
            if (self.last_error) |_| return self;
            interop.setStrAttribute(self.ref, "BUTTON3", .{}, arg);
            return self;
        }

        ///
        /// TYPE: can be BOOLEAN ('b'), LIST ('l'), OPTIONS ('o'), REAL ('A', 'a', 'R',
        /// 'r'), STRING ('m', 's'), INTEGER ('i'), DATE ('d'), FILE ('f'), COLOR
        /// ('c'), SEPARATOR ('t'), BUTTONNAMES ('u'), PARAMBOX ('x') and HANDLE ('h').
        /// And describe the type of the parameter.
        /// For all parameters.
        pub fn setType(self: Initializer, arg: [:0]const u8) Initializer {
            if (self.last_error) |_| return self;
            interop.setStrAttribute(self.ref, "TYPE", .{}, arg);
            return self;
        }

        ///
        /// VALUE - the value of the parameter.
        /// IupGetFloat and IupGetInt can also be used.
        /// For the current parameter inside the callback contains the new value that
        /// will be applied to the control, to get the old value use the VALUE
        /// attribute for the CONTROL returned Ihandle*.
        pub fn setValue(self: Initializer, arg: [:0]const u8) Initializer {
            if (self.last_error) |_| return self;
            interop.setStrAttribute(self.ref, "VALUE", .{}, arg);
            return self;
        }

        ///
        /// DIALOGTYPE, FILTER, DIRECTORY, NOCHANGEDIR, NOOVERWRITEPROMPT: used for the
        /// FILE parameter dialog.
        /// See IupFileDlg.
        /// For 'f' parameter.
        pub fn setDialogType(self: Initializer, arg: ?DialogType) Initializer {
            if (self.last_error) |_| return self;
            if (arg) |value| switch (value) {
                .Save => interop.setStrAttribute(self.ref, "DIALOGTYPE", .{}, "SAVE"),
                .Dir => interop.setStrAttribute(self.ref, "DIALOGTYPE", .{}, "DIR"),
                .Open => interop.setStrAttribute(self.ref, "DIALOGTYPE", .{}, "OPEN"),
            } else {
                interop.clearAttribute(self.ref, "DIALOGTYPE", .{});
            }
            return self;
        }

        pub fn setNoChangeDir(self: Initializer, arg: bool) Initializer {
            if (self.last_error) |_| return self;
            interop.setBoolAttribute(self.ref, "NOCHANGEDIR", .{}, arg);
            return self;
        }

        pub fn setMin(self: Initializer, arg: f64) Initializer {
            if (self.last_error) |_| return self;
            interop.setDoubleAttribute(self.ref, "MIN", .{}, arg);
            return self;
        }

        pub fn setStep(self: Initializer, arg: f64) Initializer {
            if (self.last_error) |_| return self;
            interop.setDoubleAttribute(self.ref, "STEP", .{}, arg);
            return self;
        }

        ///
        /// EXPANDWEIGHT (non inheritable) (at children only): If a child defines the
        /// expand weight, then it is used to multiply the free space used for expansion.
        /// (since 3.1)
        pub fn setExpandWeight(self: Initializer, arg: f64) Initializer {
            if (self.last_error) |_| return self;
            interop.setDoubleAttribute(self.ref, "EXPANDWEIGHT", .{}, arg);
            return self;
        }

        ///
        /// FLOATING (non inheritable) (at children only): If a child has FLOATING=YES
        /// then its size and position will be ignored by the layout processing.
        /// Default: "NO".
        /// (since 3.0)
        pub fn setFloating(self: Initializer, arg: ?Floating) Initializer {
            if (self.last_error) |_| return self;
            if (arg) |value| switch (value) {
                .Yes => interop.setStrAttribute(self.ref, "FLOATING", .{}, "YES"),
                .Ignore => interop.setStrAttribute(self.ref, "FLOATING", .{}, "IGNORE"),
                .No => interop.setStrAttribute(self.ref, "FLOATING", .{}, "NO"),
            } else {
                interop.clearAttribute(self.ref, "FLOATING", .{});
            }
            return self;
        }

        ///
        /// TABIMAGEn (non inheritable): image name to be used in the respective tab.
        /// Use IupSetHandle or IupSetAttributeHandle to associate an image to a name.
        /// n starts at 0.
        /// See also IupImage.
        /// In Motif, the image is shown only if TABTITLEn is NULL.
        /// In Windows and Motif set the BGCOLOR attribute before setting the image.
        /// When set after map will update the TABIMAGE attribute on the respective
        /// child (since 3.10).
        /// (since 3.0).
        /// TABIMAGE (non inheritable) (at children only): Same as TABIMAGEn but set in
        /// each child.
        /// Works only if set before the child is added to the tabs.
        pub fn setTabImage(self: Initializer, index: i32, arg: anytype) Initializer {
            if (self.last_error) |_| return self;
            if (interop.validateHandle(.Image, arg)) {
                interop.setHandleAttribute(self.ref, "TABIMAGE", .{index}, arg);
            } else |err| {
                self.last_error = err;
            }
            return self;
        }

        pub fn setTabImageHandleName(self: Initializer, index: i32, arg: [:0]const u8) Initializer {
            if (self.last_error) |_| return self;
            interop.setStrAttribute(self.ref, "TABIMAGE", .{index}, arg);
            return self;
        }

        ///
        /// TABTITLEn (non inheritable): Contains the text to be shown in the
        /// respective tab title.
        /// n starts at 0.
        /// If this value is NULL, it will remain empty.
        /// The "&" character can be used to define a mnemonic, the next character will
        /// be used as key.
        /// Use "&&" to show the "&" character instead on defining a mnemonic.
        /// The button can be activated from any control in the dialog using the
        /// "Alt+key" combination.
        /// (mnemonic support since 3.3).
        /// When set after map will update the TABTITLE attribute on the respective
        /// child (since 3.10).
        /// (since 3.0).
        /// TABTITLE (non inheritable) (at children only): Same as TABTITLEn but set in
        /// each child.
        /// Works only if set before the child is added to the tabs.
        pub fn setTabTitle(self: Initializer, index: i32, arg: [:0]const u8) Initializer {
            if (self.last_error) |_| return self;
            interop.setStrAttribute(self.ref, "TABTITLE", .{index}, arg);
            return self;
        }

        pub fn setLDestroyCallback(self: Initializer, callback: ?*const OnLDestroyFn) Initializer {
            const Handler = CallbackHandler(Self, OnLDestroyFn, "LDESTROY_CB");
            Handler.setCallback(self.ref, callback);
            return self;
        }

        ///
        /// DESTROY_CB DESTROY_CB Called right before an element is destroyed.
        /// Callback int function(Ihandle *ih); [in C] ih:destroy_cb() -> (ret: number)
        /// [in Lua] ih: identifier of the element that activated the event.
        /// Notes If the dialog is visible then it is hidden before it is destroyed.
        /// The callback will be called right after it is hidden.
        /// The callback will be called before all other destroy procedures.
        /// For instance, if the element has children then it is called before the
        /// children are destroyed.
        /// For language binding implementations use the callback name "LDESTROY_CB" to
        /// release memory allocated by the binding for the element.
        /// Also the callback will be called before the language callback.
        /// Affects All.
        pub fn setDestroyCallback(self: Initializer, callback: ?*const OnDestroyFn) Initializer {
            const Handler = CallbackHandler(Self, OnDestroyFn, "DESTROY_CB");
            Handler.setCallback(self.ref, callback);
            return self;
        }

        ///
        /// MAP_CB MAP_CB Called right after an element is mapped and its attributes
        /// updated in IupMap.
        /// When the element is a dialog, it is called after the layout is updated.
        /// For all other elements is called before the layout is updated, so the
        /// element current size will still be 0x0 during MAP_CB (since 3.14).
        /// Callback int function(Ihandle *ih); [in C] ih:map_cb() -> (ret: number) [in
        /// Lua] ih: identifier of the element that activated the event.
        /// Affects All that have a native representation.
        pub fn setMapCallback(self: Initializer, callback: ?*const OnMapFn) Initializer {
            const Handler = CallbackHandler(Self, OnMapFn, "MAP_CB");
            Handler.setCallback(self.ref, callback);
            return self;
        }

        pub fn setPostMessageCallback(self: Initializer, callback: ?*const OnPostMessageFn) Initializer {
            const Handler = CallbackHandler(Self, OnPostMessageFn, "POSTMESSAGE_CB");
            Handler.setCallback(self.ref, callback);
            return self;
        }

        ///
        /// UNMAP_CB UNMAP_CB Called right before an element is unmapped.
        /// Callback int function(Ihandle *ih); [in C] ih:unmap_cb() -> (ret: number)
        /// [in Lua] ih: identifier of the element that activated the event.
        /// Affects All that have a native representation.
        pub fn setUnmapCallback(self: Initializer, callback: ?*const OnUnmapFn) Initializer {
            const Handler = CallbackHandler(Self, OnUnmapFn, "UNMAP_CB");
            Handler.setCallback(self.ref, callback);
            return self;
        }
    };

    pub fn setStrAttribute(self: *Self, attribute: [:0]const u8, arg: [:0]const u8) void {
        interop.setStrAttribute(self, attribute, .{}, arg);
    }

    pub fn getStrAttribute(self: *Self, attribute: [:0]const u8) [:0]const u8 {
        return interop.getStrAttribute(self, attribute, .{});
    }

    pub fn setIntAttribute(self: *Self, attribute: [:0]const u8, arg: i32) void {
        interop.setIntAttribute(self, attribute, .{}, arg);
    }

    pub fn getIntAttribute(self: *Self, attribute: [:0]const u8) i32 {
        return interop.getIntAttribute(self, attribute, .{});
    }

    pub fn setBoolAttribute(self: *Self, attribute: [:0]const u8, arg: bool) void {
        interop.setBoolAttribute(self, attribute, .{}, arg);
    }

    pub fn getBoolAttribute(self: *Self, attribute: [:0]const u8) bool {
        return interop.getBoolAttribute(self, attribute, .{});
    }

    pub fn getPtrAttribute(self: *Self, comptime T: type, attribute: [:0]const u8) ?*T {
        return interop.getPtrAttribute(T, self, attribute, .{});
    }

    pub fn setPtrAttribute(self: *Self, comptime T: type, attribute: [:0]const u8, value: ?*T) void {
        interop.setPtrAttribute(T, self, attribute, .{}, value);
    }

    pub fn setHandle(self: *Self, arg: [:0]const u8) void {
        interop.setHandle(self, arg);
    }

    pub fn fromHandleName(handle_name: [:0]const u8) ?*Self {
        return interop.fromHandleName(Self, handle_name);
    }

    pub fn postMessage(self: *Self, s: [:0]const u8, i: i32, f: f64, p: ?*anyopaque) void {
        return interop.postMessage(self, s, i, f, p);
    }

    ///
    /// Creates an interface element given its class name and parameters.
    /// After creation the element still needs to be attached to a container and mapped to the native system so it can be visible.
    pub fn init() Initializer {
        var handle = interop.create(Self);

        if (handle) |valid| {
            return .{
                .ref = @as(*Self, @ptrCast(valid)),
            };
        } else {
            return .{ .ref = undefined, .last_error = Error.NotInitialized };
        }
    }

    ///
    /// Destroys an interface element and all its children.
    /// Only dialogs, timers, popup menus and images should be normally destroyed, but detached elements can also be destroyed.
    pub fn deinit(self: *Self) void {
        interop.destroy(self);
    }

    ///
    /// Creates (maps) the native interface objects corresponding to the given IUP interface elements.
    /// It will also called recursively to create the native element of all the children in the element's tree.
    /// The element must be already attached to a mapped container, except the dialog. A child can only be mapped if its parent is already mapped.
    /// This function is automatically called before the dialog is shown in IupShow, IupShowXY or IupPopup.
    /// If the element is a dialog then the abstract layout will be updated even if the dialog is already mapped. If the dialog is visible the elements will be immediately repositioned. Calling IupMap for an already mapped dialog is the same as only calling IupRefresh for the dialog.
    /// Calling IupMap for an already mapped element that is not a dialog does nothing.
    /// If you add new elements to an already mapped dialog you must call IupMap for that elements. And then call IupRefresh to update the dialog layout.
    /// If the WID attribute of an element is NULL, it means the element was not already mapped. Some containers do not have a native element associated, like VBOX and HBOX. In this case their WID is a fake value (void*)(-1).
    /// It is useful for the application to call IupMap when the value of the WID attribute must be known, i.e. the native element must exist, before a dialog is made visible.
    /// The MAP_CB callback is called at the end of the IupMap function, after all processing, so it can also be used to create other things that depend on the WID attribute. But notice that for non dialog elements it will be called before the dialog layout has been updated, so the element current size will still be 0x0 (since 3.14).
    pub fn map(self: *Self) !void {
        try interop.map(self);
    }

    ///
    ///
    pub fn getDialog(self: *Self) ?*iup.Dialog {
        return interop.getDialog(self);
    }

    ///
    /// Returns the the child element that has the NAME attribute equals to the given value on the same dialog hierarchy.
    /// Works also for children of a menu that is associated with a dialog.
    pub fn getDialogChild(self: *Self, byName: [:0]const u8) ?Element {
        return interop.getDialogChild(self, byName);
    }

    ///
    /// Updates the size and layout of all controls in the same dialog.
    /// To be used after changing size attributes, or attributes that affect the size of the control. Can be used for any element inside a dialog, but the layout of the dialog and all controls will be updated. It can change the layout of all the controls inside the dialog because of the dynamic layout positioning.
    pub fn refresh(self: *Self) void {
        Impl(Self).refresh(self);
    }

    ///
    /// Updates the size and layout of all controls in the same dialog.
    pub fn update(self: *Self) void {
        Impl(Self).update(self);
    }

    ///
    /// Updates the size and layout of all controls in the same dialog.
    pub fn updateChildren(self: *Self) void {
        Impl(Self).updateChildren(self);
    }

    ///
    /// Force the element and its children to be redrawn immediately.
    pub fn redraw(self: *Self, redraw_children: bool) void {
        Impl(Self).redraw(self, redraw_children);
    }

    pub fn getDirectory(self: *Self) [:0]const u8 {
        return interop.getStrAttribute(self, "DIRECTORY", .{});
    }

    pub fn setDirectory(self: *Self, arg: [:0]const u8) void {
        interop.setStrAttribute(self, "DIRECTORY", .{}, arg);
    }

    pub fn getNoOverwritePrompt(self: *Self) bool {
        return interop.getBoolAttribute(self, "NOOVERWRITEPROMPT", .{});
    }

    pub fn setNoOverwritePrompt(self: *Self, arg: bool) void {
        interop.setBoolAttribute(self, "NOOVERWRITEPROMPT", .{}, arg);
    }

    ///
    /// TITLE: text of the parameter, used as label.
    /// For all parameters.
    pub fn getTitle(self: *Self) [:0]const u8 {
        return interop.getStrAttribute(self, "TITLE", .{});
    }

    ///
    /// TITLE: text of the parameter, used as label.
    /// For all parameters.
    pub fn setTitle(self: *Self, arg: [:0]const u8) void {
        interop.setStrAttribute(self, "TITLE", .{}, arg);
    }

    ///
    /// MULTILINE: can be Yes or No.
    /// Defines if the edit box can have more than one line.
    /// For 'm' parameter.
    pub fn getMultiline(self: *Self) bool {
        return interop.getBoolAttribute(self, "MULTILINE", .{});
    }

    ///
    /// MULTILINE: can be Yes or No.
    /// Defines if the edit box can have more than one line.
    /// For 'm' parameter.
    pub fn setMultiline(self: *Self, arg: bool) void {
        interop.setBoolAttribute(self, "MULTILINE", .{}, arg);
    }

    pub fn getFilter(self: *Self) [:0]const u8 {
        return interop.getStrAttribute(self, "FILTER", .{});
    }

    pub fn setFilter(self: *Self, arg: [:0]const u8) void {
        interop.setStrAttribute(self, "FILTER", .{}, arg);
    }

    ///
    /// TIP: text of the tip.
    /// For all parameters.
    pub fn getTip(self: *Self) [:0]const u8 {
        return interop.getStrAttribute(self, "TIP", .{});
    }

    ///
    /// TIP: text of the tip.
    /// For all parameters.
    pub fn setTip(self: *Self, arg: [:0]const u8) void {
        interop.setStrAttribute(self, "TIP", .{}, arg);
    }

    pub fn getMax(self: *Self) f64 {
        return interop.getDoubleAttribute(self, "MAX", .{});
    }

    pub fn setMax(self: *Self, arg: f64) void {
        interop.setDoubleAttribute(self, "MAX", .{}, arg);
    }

    ///
    /// BUTTON1, BUTTON2, BUTTON3: button titles.
    /// Default is "OK/Cancel/Help" for regular IupGetParam, and "Apply/Reset/Help"
    /// when IupParamBox is directly used.
    /// For 'u' parameter.
    pub fn getButton1(self: *Self) [:0]const u8 {
        return interop.getStrAttribute(self, "BUTTON1", .{});
    }

    ///
    /// BUTTON1, BUTTON2, BUTTON3: button titles.
    /// Default is "OK/Cancel/Help" for regular IupGetParam, and "Apply/Reset/Help"
    /// when IupParamBox is directly used.
    /// For 'u' parameter.
    pub fn setButton1(self: *Self, arg: [:0]const u8) void {
        interop.setStrAttribute(self, "BUTTON1", .{}, arg);
    }

    pub fn getButton2(self: *Self) [:0]const u8 {
        return interop.getStrAttribute(self, "BUTTON2", .{});
    }

    pub fn setButton2(self: *Self, arg: [:0]const u8) void {
        interop.setStrAttribute(self, "BUTTON2", .{}, arg);
    }

    ///
    /// MASK: mask for the edit box input.
    /// For 's' and 'm' parameters.
    pub fn getMask(self: *Self) [:0]const u8 {
        return interop.getStrAttribute(self, "MASK", .{});
    }

    ///
    /// MASK: mask for the edit box input.
    /// For 's' and 'm' parameters.
    pub fn setMask(self: *Self, arg: [:0]const u8) void {
        interop.setStrAttribute(self, "MASK", .{}, arg);
    }

    pub fn getButton3(self: *Self) [:0]const u8 {
        return interop.getStrAttribute(self, "BUTTON3", .{});
    }

    pub fn setButton3(self: *Self, arg: [:0]const u8) void {
        interop.setStrAttribute(self, "BUTTON3", .{}, arg);
    }

    ///
    /// TYPE: can be BOOLEAN ('b'), LIST ('l'), OPTIONS ('o'), REAL ('A', 'a', 'R',
    /// 'r'), STRING ('m', 's'), INTEGER ('i'), DATE ('d'), FILE ('f'), COLOR
    /// ('c'), SEPARATOR ('t'), BUTTONNAMES ('u'), PARAMBOX ('x') and HANDLE ('h').
    /// And describe the type of the parameter.
    /// For all parameters.
    pub fn getType(self: *Self) [:0]const u8 {
        return interop.getStrAttribute(self, "TYPE", .{});
    }

    ///
    /// TYPE: can be BOOLEAN ('b'), LIST ('l'), OPTIONS ('o'), REAL ('A', 'a', 'R',
    /// 'r'), STRING ('m', 's'), INTEGER ('i'), DATE ('d'), FILE ('f'), COLOR
    /// ('c'), SEPARATOR ('t'), BUTTONNAMES ('u'), PARAMBOX ('x') and HANDLE ('h').
    /// And describe the type of the parameter.
    /// For all parameters.
    pub fn setType(self: *Self, arg: [:0]const u8) void {
        interop.setStrAttribute(self, "TYPE", .{}, arg);
    }

    ///
    /// VALUE - the value of the parameter.
    /// IupGetFloat and IupGetInt can also be used.
    /// For the current parameter inside the callback contains the new value that
    /// will be applied to the control, to get the old value use the VALUE
    /// attribute for the CONTROL returned Ihandle*.
    pub fn getValue(self: *Self) [:0]const u8 {
        return interop.getStrAttribute(self, "VALUE", .{});
    }

    ///
    /// VALUE - the value of the parameter.
    /// IupGetFloat and IupGetInt can also be used.
    /// For the current parameter inside the callback contains the new value that
    /// will be applied to the control, to get the old value use the VALUE
    /// attribute for the CONTROL returned Ihandle*.
    pub fn setValue(self: *Self, arg: [:0]const u8) void {
        interop.setStrAttribute(self, "VALUE", .{}, arg);
    }

    ///
    /// DIALOGTYPE, FILTER, DIRECTORY, NOCHANGEDIR, NOOVERWRITEPROMPT: used for the
    /// FILE parameter dialog.
    /// See IupFileDlg.
    /// For 'f' parameter.
    pub fn getDialogType(self: *Self) ?DialogType {
        var ret = interop.getStrAttribute(self, "DIALOGTYPE", .{});

        if (std.ascii.eqlIgnoreCase("SAVE", ret)) return .Save;
        if (std.ascii.eqlIgnoreCase("DIR", ret)) return .Dir;
        if (std.ascii.eqlIgnoreCase("OPEN", ret)) return .Open;
        return null;
    }

    ///
    /// DIALOGTYPE, FILTER, DIRECTORY, NOCHANGEDIR, NOOVERWRITEPROMPT: used for the
    /// FILE parameter dialog.
    /// See IupFileDlg.
    /// For 'f' parameter.
    pub fn setDialogType(self: *Self, arg: ?DialogType) void {
        if (arg) |value| switch (value) {
            .Save => interop.setStrAttribute(self, "DIALOGTYPE", .{}, "SAVE"),
            .Dir => interop.setStrAttribute(self, "DIALOGTYPE", .{}, "DIR"),
            .Open => interop.setStrAttribute(self, "DIALOGTYPE", .{}, "OPEN"),
        } else {
            interop.clearAttribute(self, "DIALOGTYPE", .{});
        }
    }

    pub fn getNoChangeDir(self: *Self) bool {
        return interop.getBoolAttribute(self, "NOCHANGEDIR", .{});
    }

    pub fn setNoChangeDir(self: *Self, arg: bool) void {
        interop.setBoolAttribute(self, "NOCHANGEDIR", .{}, arg);
    }

    pub fn getMin(self: *Self) f64 {
        return interop.getDoubleAttribute(self, "MIN", .{});
    }

    pub fn setMin(self: *Self, arg: f64) void {
        interop.setDoubleAttribute(self, "MIN", .{}, arg);
    }

    pub fn getStep(self: *Self) f64 {
        return interop.getDoubleAttribute(self, "STEP", .{});
    }

    pub fn setStep(self: *Self, arg: f64) void {
        interop.setDoubleAttribute(self, "STEP", .{}, arg);
    }

    ///
    /// EXPANDWEIGHT (non inheritable) (at children only): If a child defines the
    /// expand weight, then it is used to multiply the free space used for expansion.
    /// (since 3.1)
    pub fn getExpandWeight(self: *Self) f64 {
        return interop.getDoubleAttribute(self, "EXPANDWEIGHT", .{});
    }

    ///
    /// EXPANDWEIGHT (non inheritable) (at children only): If a child defines the
    /// expand weight, then it is used to multiply the free space used for expansion.
    /// (since 3.1)
    pub fn setExpandWeight(self: *Self, arg: f64) void {
        interop.setDoubleAttribute(self, "EXPANDWEIGHT", .{}, arg);
    }

    ///
    /// FLOATING (non inheritable) (at children only): If a child has FLOATING=YES
    /// then its size and position will be ignored by the layout processing.
    /// Default: "NO".
    /// (since 3.0)
    pub fn getFloating(self: *Self) ?Floating {
        var ret = interop.getStrAttribute(self, "FLOATING", .{});

        if (std.ascii.eqlIgnoreCase("YES", ret)) return .Yes;
        if (std.ascii.eqlIgnoreCase("IGNORE", ret)) return .Ignore;
        if (std.ascii.eqlIgnoreCase("NO", ret)) return .No;
        return null;
    }

    ///
    /// FLOATING (non inheritable) (at children only): If a child has FLOATING=YES
    /// then its size and position will be ignored by the layout processing.
    /// Default: "NO".
    /// (since 3.0)
    pub fn setFloating(self: *Self, arg: ?Floating) void {
        if (arg) |value| switch (value) {
            .Yes => interop.setStrAttribute(self, "FLOATING", .{}, "YES"),
            .Ignore => interop.setStrAttribute(self, "FLOATING", .{}, "IGNORE"),
            .No => interop.setStrAttribute(self, "FLOATING", .{}, "NO"),
        } else {
            interop.clearAttribute(self, "FLOATING", .{});
        }
    }

    ///
    /// TABIMAGEn (non inheritable): image name to be used in the respective tab.
    /// Use IupSetHandle or IupSetAttributeHandle to associate an image to a name.
    /// n starts at 0.
    /// See also IupImage.
    /// In Motif, the image is shown only if TABTITLEn is NULL.
    /// In Windows and Motif set the BGCOLOR attribute before setting the image.
    /// When set after map will update the TABIMAGE attribute on the respective
    /// child (since 3.10).
    /// (since 3.0).
    /// TABIMAGE (non inheritable) (at children only): Same as TABIMAGEn but set in
    /// each child.
    /// Works only if set before the child is added to the tabs.
    pub fn getTabImage(self: *Self, index: i32) ?iup.Element {
        if (interop.getHandleAttribute(self, "TABIMAGE", .{index})) |handle| {
            return iup.Element.fromHandle(handle);
        } else {
            return null;
        }
    }

    ///
    /// TABIMAGEn (non inheritable): image name to be used in the respective tab.
    /// Use IupSetHandle or IupSetAttributeHandle to associate an image to a name.
    /// n starts at 0.
    /// See also IupImage.
    /// In Motif, the image is shown only if TABTITLEn is NULL.
    /// In Windows and Motif set the BGCOLOR attribute before setting the image.
    /// When set after map will update the TABIMAGE attribute on the respective
    /// child (since 3.10).
    /// (since 3.0).
    /// TABIMAGE (non inheritable) (at children only): Same as TABIMAGEn but set in
    /// each child.
    /// Works only if set before the child is added to the tabs.
    pub fn setTabImage(self: *Self, index: i32, arg: anytype) !void {
        try interop.validateHandle(.Image, arg);
        interop.setHandleAttribute(self, "TABIMAGE", .{index}, arg);
    }

    pub fn setTabImageHandleName(self: *Self, index: i32, arg: [:0]const u8) void {
        interop.setStrAttribute(self, "TABIMAGE", .{index}, arg);
    }

    ///
    /// TABTITLEn (non inheritable): Contains the text to be shown in the
    /// respective tab title.
    /// n starts at 0.
    /// If this value is NULL, it will remain empty.
    /// The "&" character can be used to define a mnemonic, the next character will
    /// be used as key.
    /// Use "&&" to show the "&" character instead on defining a mnemonic.
    /// The button can be activated from any control in the dialog using the
    /// "Alt+key" combination.
    /// (mnemonic support since 3.3).
    /// When set after map will update the TABTITLE attribute on the respective
    /// child (since 3.10).
    /// (since 3.0).
    /// TABTITLE (non inheritable) (at children only): Same as TABTITLEn but set in
    /// each child.
    /// Works only if set before the child is added to the tabs.
    pub fn getTabTitle(self: *Self, index: i32) [:0]const u8 {
        return interop.getStrAttribute(self, "TABTITLE", .{index});
    }

    ///
    /// TABTITLEn (non inheritable): Contains the text to be shown in the
    /// respective tab title.
    /// n starts at 0.
    /// If this value is NULL, it will remain empty.
    /// The "&" character can be used to define a mnemonic, the next character will
    /// be used as key.
    /// Use "&&" to show the "&" character instead on defining a mnemonic.
    /// The button can be activated from any control in the dialog using the
    /// "Alt+key" combination.
    /// (mnemonic support since 3.3).
    /// When set after map will update the TABTITLE attribute on the respective
    /// child (since 3.10).
    /// (since 3.0).
    /// TABTITLE (non inheritable) (at children only): Same as TABTITLEn but set in
    /// each child.
    /// Works only if set before the child is added to the tabs.
    pub fn setTabTitle(self: *Self, index: i32, arg: [:0]const u8) void {
        interop.setStrAttribute(self, "TABTITLE", .{index}, arg);
    }

    pub fn setLDestroyCallback(self: *Self, callback: ?*const OnLDestroyFn) void {
        const Handler = CallbackHandler(Self, OnLDestroyFn, "LDESTROY_CB");
        Handler.setCallback(self, callback);
    }

    ///
    /// DESTROY_CB DESTROY_CB Called right before an element is destroyed.
    /// Callback int function(Ihandle *ih); [in C] ih:destroy_cb() -> (ret: number)
    /// [in Lua] ih: identifier of the element that activated the event.
    /// Notes If the dialog is visible then it is hidden before it is destroyed.
    /// The callback will be called right after it is hidden.
    /// The callback will be called before all other destroy procedures.
    /// For instance, if the element has children then it is called before the
    /// children are destroyed.
    /// For language binding implementations use the callback name "LDESTROY_CB" to
    /// release memory allocated by the binding for the element.
    /// Also the callback will be called before the language callback.
    /// Affects All.
    pub fn setDestroyCallback(self: *Self, callback: ?*const OnDestroyFn) void {
        const Handler = CallbackHandler(Self, OnDestroyFn, "DESTROY_CB");
        Handler.setCallback(self, callback);
    }

    ///
    /// MAP_CB MAP_CB Called right after an element is mapped and its attributes
    /// updated in IupMap.
    /// When the element is a dialog, it is called after the layout is updated.
    /// For all other elements is called before the layout is updated, so the
    /// element current size will still be 0x0 during MAP_CB (since 3.14).
    /// Callback int function(Ihandle *ih); [in C] ih:map_cb() -> (ret: number) [in
    /// Lua] ih: identifier of the element that activated the event.
    /// Affects All that have a native representation.
    pub fn setMapCallback(self: *Self, callback: ?*const OnMapFn) void {
        const Handler = CallbackHandler(Self, OnMapFn, "MAP_CB");
        Handler.setCallback(self, callback);
    }

    pub fn setPostMessageCallback(self: *Self, callback: ?*const OnPostMessageFn) void {
        const Handler = CallbackHandler(Self, OnPostMessageFn, "POSTMESSAGE_CB");
        Handler.setCallback(self, callback);
    }

    ///
    /// UNMAP_CB UNMAP_CB Called right before an element is unmapped.
    /// Callback int function(Ihandle *ih); [in C] ih:unmap_cb() -> (ret: number)
    /// [in Lua] ih: identifier of the element that activated the event.
    /// Affects All that have a native representation.
    pub fn setUnmapCallback(self: *Self, callback: ?*const OnUnmapFn) void {
        const Handler = CallbackHandler(Self, OnUnmapFn, "UNMAP_CB");
        Handler.setCallback(self, callback);
    }
};
