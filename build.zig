const std = @import("std");
const Builder = std.build.Builder;
const Pkg = std.build.Pkg;

fn addIupReference(b: *std.build.Builder, artifact: *std.build.LibExeObjStep) !void {
    const iup_libs_path = "lib";
    artifact.addIncludePath(iup_libs_path ++ "/include");

    const iup_libs = .{
        "iupcd",
        "iupgl",
        "iup_mglplot",
        "iup",
        "iupcontrols",
        "iupimglib",
        "iup_plot",
        "iuptuio",
        "iupglcontrols",
        "iupim",
        "iup_scintilla",
    };

    artifact.addLibraryPath(iup_libs_path);
         
    var copy_step = b.addInstallDirectory(.{
        .source_dir = iup_libs_path,
        .install_dir = .prefix,
        .install_subdir = "",
        .exclude_extensions = &.{ ".o", ".a", "include", "Lua51", "Lua52", "Lua53", "Lua54" },
    });
    artifact.step.dependOn(&copy_step.step);

    inline for (iup_libs) |lib| {
        artifact.linkSystemLibrary(lib);
    }

    if (artifact.target.isWindows()) {
        const windows_libs = .{
            "iupole",   "iupgl",    "zlib1",
            "Gdi32",    "User32",   "Shell32",
            "Comctl32", "Comdlg32", "Ole32",
            "Advapi32",
        };

        inline for (windows_libs) |lib| {
            artifact.linkSystemLibrary(lib);
        }

        artifact.subsystem = if (artifact.kind == .exe) .Windows else .Console;
    }
}

pub fn build(b: *Builder) !void {
    const mode = b.standardReleaseOptions();

    var main_tests = b.addTestExe("test", "src/iup.zig");
    main_tests.setBuildMode(mode);
    main_tests.linkLibC();
    try addIupReference(b, main_tests);

    const test_step = b.step("test", "Run bindings tests");
    const main_test_cmd = main_tests.run();
    main_test_cmd.step.dependOn(&b.addInstallArtifact(main_tests).step);    
    test_step.dependOn(&main_test_cmd.step);

    var @"7gui_test" = b.addTestExe("7gui_test", "src/7gui/tests.zig");
    @"7gui_test".setMainPkgPath("src");
    @"7gui_test".setBuildMode(mode);
    @"7gui_test".linkLibC();
    try addIupReference(b, @"7gui_test");

    const @"7gui_test_step" = b.step("7gui_test", "7GUI demo tests");
    const  @"7gui_test_cmd" =   @"7gui_test".run();
    @"7gui_test_cmd".step.dependOn(&b.addInstallArtifact( @"7gui_test").step);    
    @"7gui_test_step".dependOn(&@"7gui_test".step);    

    addExample(b, "run", "IUP notepad example", "src/notepad_example.zig");
    addExample(b, "tabs", "IUP tabs example", "src/tabs_example.zig");
    addExample(b, "button", "IUP buttons example", "src/button_example.zig");
    addExample(b, "image", "IUP image example", "src/image_example.zig");
    addExample(b, "list", "IUP list example", "src/list_example.zig");
    addExample(b, "tree", "IUP tree example", "src/tree_example.zig");
    addExample(b, "mdi", "IUP mdi example", "src/mdi_example.zig");
    addExample(b, "gauge", "IUP gauge example", "src/gauge_example.zig");

    addExample(b, "counter", "7GUI Counter", "src/7gui/counter.zig");
    addExample(b, "tempConv", "7GUI Temperature Converter", "src/7gui/temp_conv.zig");
    addExample(b, "bookFlight", "7GUI Flight Booker", "src/7gui/book_flight.zig");
    addExample(b, "timer", "7GUI Timer", "src/7gui/timer.zig");
    addExample(b, "crud", "7GUI Crud", "src/7gui/crud.zig");
    addExample(b, "circle", "7GUI Circle Drawer", "src/7gui/circle.zig");
    addExample(b, "cells", "7GUI Cells", "src/7gui/cells.zig");
}

fn addExample(b: *Builder, comptime name: []const u8, comptime description: []const u8, comptime file: []const u8) void {
    const mode = b.standardReleaseOptions();

    const example = b.addExecutable(name, file);
    example.setMainPkgPath("src");

    example.setBuildMode(mode);
    example.linkLibC();
    try addIupReference(b, example);

    const example_cmd = example.run();
    example_cmd.step.dependOn(&b.addInstallArtifact(example).step);

    const example_step = b.step(name, description);
    example_step.dependOn(&example_cmd.step);
}
