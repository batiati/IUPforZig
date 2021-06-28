/// Creates a tree with some branches and leaves. 
/// Two callbacks are registered: one deletes marked nodes when the Del key is pressed, 
/// and the other, called when the right mouse button is pressed, opens a menu with options.
/// From original example in C
/// https://webserver2.tecgraf.puc-rio.br/iup/examples/C/tree.c
const std = @import("std");
const iup = @import("iup.zig");

usingnamespace iup;

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


    std.debug.print("STARTING\n", .{} );

    tree.setStrAttribute("VALUE","ROOT");
    while(true) {

        var x = tree.getValue();

        var title = tree.getTitle(x);
        var depth = tree.getDepth(x);
        std.debug.print("id={} +{}:{s}\n", .{ x, depth, title} );

        tree.setStrAttribute("VALUE", "NEXT");
        var next = tree.getValue();
        if (x == next) break;

    }

}

fn rightclick_cb(tree: *Tree, id: i32) !void {
    var popup = try (Menu.init().setChildren(
        .{
            Item.init().setTitle("Add Leaf").setActionCallback(addFeaf),
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
    popup.popup(.MousePos, .MousePos);
}

fn removeNode(item: *Item) !void {
    var tree = item.getPtrAttribute(Tree, "tree").?;
    tree.delNode(0, .Marked);
}

fn addFeaf(item: *Item) !void {
    var tree = item.getPtrAttribute(Tree, "tree").?;
    var id = tree.getValue();
    tree.addLeaf(id, "");
    var new_id = tree.getLastAddNode();
    tree.setValue(new_id);
    tree.rename();
}

fn addBranch(item: *Item) !void {
    var tree = item.getPtrAttribute(Tree, "tree").?;
    var id = tree.getValue();
    tree.addBranch(id, "");
    var new_id = tree.getLastAddNode();
    tree.setValue(new_id);
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
    if (key == keys.DEL) {
        tree.delNode(0, .Marked);
    }
}
