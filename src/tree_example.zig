/// Creates a tree with some branches and leaves. 
/// Two callbacks are registered: one deletes marked nodes when the Del key is pressed, 
/// and the other, called when the right mouse button is pressed, opens a menu with options.
/// From original example in C
/// https://webserver2.tecgraf.puc-rio.br/iup/examples/C/tree.c
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
const Tree = iup.Tree;
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

    var dlg = try createDialog();
    defer dlg.deinit();

    try dlg.showXY(.Center, .Center);
    initTree(dlg);

    try MainLoop.beginLoop();
}

fn createDialog() !*Dialog {
    var tree = try createTree();

    return try (Dialog.init()
        .setTitle("IUP for Zig - Tree")
        .setSize(.Half, .Half)
        .setChildren(
        .{
            VBox.init()
                .setMargin(20, 20)
                .setGap(10)
                .setChildren(
                .{
                    HBox.init()
                        .setChildren(
                        .{
                            tree,
                        },
                    ),
                },
            ),
        },
    ).unwrap());
}

fn createTree() !*Tree {
    var tree = try (Tree.init()
        .setName("tree")
        .setShowRename(true)
        .setRightClickCallback(rightclick_cb)
        .setKAnyCallback(k_any_cb)
        .unwrap());

    return tree;
}

fn initTree(dialog: *Dialog) void {
    var tree = dialog.getDialogChild("tree").?.Tree;

    tree.setTitle(0, "Figures");
    tree.addBranch(0, "3D");
    tree.addBranch(1, "parallelogram");
    tree.addLeaf(2, "diamond");
    tree.addLeaf(2, "square");

    tree.addBranch(0, "2D");
    tree.addBranch(1, "triangle");
    tree.addLeaf(2, "scalenus");
    tree.addLeaf(2, "isoceles");
    tree.addLeaf(2, "equilateral");
    tree.addLeaf(0, "Test");
}

fn rightclick_cb(tree: *Tree, id: i32) !void {
    var popup = try (Menu.init().setChildren(
        .{
            Item.init().setTitle("Add Leaf").setActionCallback(addLeaf),
            Item.init().setTitle("Add Branch").setActionCallback(addBranch),
            Item.init().setTitle("Rename Node").setActionCallback(rename),
            Item.init().setTitle("Remove Node").setActionCallback(removeNode),
            SubMenu.init()
                .setTitle("Selection")
                .setChildren(
                .{
                    Item.init().setTitle("ROOT").setActionCallback(selectNode),
                    Item.init().setTitle("LAST").setActionCallback(selectNode),
                    Item.init().setTitle("PGUP").setActionCallback(selectNode),
                    Item.init().setTitle("PGDN").setActionCallback(selectNode),
                    Item.init().setTitle("NEXT").setActionCallback(selectNode),
                    Item.init().setTitle("PREVIOUS").setActionCallback(selectNode),
                    Separator.init(),
                    Item.init().setTitle("INVERT").setActionCallback(selectNode),
                    Item.init().setTitle("BLOCK").setActionCallback(selectNode),
                    Item.init().setTitle("CLEARALL").setActionCallback(selectNode),
                    Item.init().setTitle("MARKALL").setActionCallback(selectNode),
                    Item.init().setTitle("INVERTALL").setActionCallback(selectNode),
                },
            ),
        },
    )
        .unwrap());

    // Can't use "getDialogChild" function on callbacks, because this is a dettached popup
    // Original example sets a GlobalHandler to retrieve the tree
    // Here we use a custom PtrAttribute to access the tree
    popup.setPtrAttribute(Tree, "tree", tree);
    defer popup.deinit();

    tree.setValue(id);
    try popup.popup(.MousePos, .MousePos);
}

fn removeNode(item: *Item) !void {
    var tree = item.getPtrAttribute(Tree, "tree").?;

    const node = tree.getValue();
    tree.delNode(node, .Selected);
}

fn addLeaf(item: *Item) !void {
    var tree = item.getPtrAttribute(Tree, "tree").?;
    var node = tree.getValue();
    tree.addLeaf(node, "");
    var new_node = tree.getLastAddNode();

    std.debug.print("new_node {}\n", .{new_node});
    tree.setValue(new_node);
    std.debug.print("current_node {}\n", .{tree.getValue()});
    tree.rename();
}

fn addBranch(item: *Item) !void {
    var tree = item.getPtrAttribute(Tree, "tree").?;
    var node = tree.getValue();
    tree.addBranch(node, "");
    var new_node = tree.getLastAddNode();

    tree.setValue(new_node);
    tree.rename();
}

fn rename(item: *Item) !void {
    var tree = item.getPtrAttribute(Tree, "tree").?;
    tree.rename();
}

fn selectNode(item: *Item) anyerror!void {
    var tree = item.getPtrAttribute(Tree, "tree").?;
    const value = item.getTitle();

    // Fix this:
    // Value can be a int or one of relative nodes "NEXT", "PREVIOUS", "ROOT", etc
    // use a union for that?
    tree.setStrAttribute("VALUE", value);
}

fn k_any_cb(tree: *Tree, key: i32) !void {
    if (key == iup.keys.DEL) {
        const node = tree.getValue();
        tree.delNode(node, .Selected);
    }
}
