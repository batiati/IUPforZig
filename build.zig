const std = @import("std");
const Builder = std.build.Builder;
const Pkg = std.build.Pkg;

fn addIupReference(b: *std.build.Builder, artifact: *std.build.LibExeObjStep) !void {
    const iup_libs_path = "lib";
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

    artifact.addIncludePath("lib/include");
    artifact.addLibraryPath(iup_libs_path);

    var install_step = b.addInstallArtifact(artifact);
    var copy_step = b.addInstallDirectory(.{
        .source_dir = iup_libs_path,
        .install_dir = install_step.dest_dir,
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

        artifact.subsystem = if (artifact.kind == .test_exe) .Console else .Windows;
    }
}

pub fn build(b: *Builder) !void {
    const mode = b.standardReleaseOptions();

    var main_tests = b.addTestExe("test", "src/iup.zig");
    main_tests.setBuildMode(mode);
    main_tests.linkLibC();
    try addIupReference(b, main_tests);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.run().step);

    addExample(b, "run", "src/notepad_example.zig");
    addExample(b, "tabs", "src/tabs_example.zig");
    addExample(b, "button", "src/button_example.zig");
    addExample(b, "image", "src/image_example.zig");
    addExample(b, "list", "src/list_example.zig");
    addExample(b, "tree", "src/tree_example.zig");
    addExample(b, "mdi", "src/mdi_example.zig");
    addExample(b, "gauge", "src/gauge_example.zig");

    addExample(b, "counter", "1. Counter", "src/7gui/counter.zig");
    addExample(b, "tempConv", "2. Temperature Converter", "src/7gui/temp_conv.zig");
    addExample(b, "bookFlight", "3. Flight Booker", "src/7gui/book_flight.zig");
    addExample(b, "timer", "4. Timer", "src/7gui/timer.zig");
    addExample(b, "crud", "5. Crud", "src/7gui/crud.zig");
    addExample(b, "circle", "6. Circle Drawer", "src/7gui/circle.zig");
    addExample(b, "cells", "7. Cells", "src/7gui/cells.zig");    
}

fn addExample(b: *Builder, comptime name: []const u8, comptime file: []const u8) void {
    const mode = b.standardReleaseOptions();

    const example = b.addExecutable(name, file);
    example.setBuildMode(mode);
    example.linkLibC();
    try addIupReference(b, example);

    const example_cmd = example.run();
    example_cmd.step.dependOn(&b.addInstallArtifact(example).step);

    const example_step = b.step(name, "Example: " ++ name);
    example_step.dependOn(&example_cmd.step);
}
