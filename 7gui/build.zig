const std = @import("std");
const Builder = std.build.Builder;
const Pkg = std.build.Pkg;

fn addIupReference(step: *std.build.LibExeObjStep) !void {
    if (step.target.isWindows()) {

        // workarround, forcing MSVC ABI
        step.target.abi = .msvc;

        step.linkSystemLibrary("Gdi32");
        step.linkSystemLibrary("User32");
        step.linkSystemLibrary("Shell32");
        step.linkSystemLibrary("Comctl32");
        step.linkSystemLibrary("Comdlg32");
        step.linkSystemLibrary("Ole32");
        step.linkSystemLibrary("Advapi32");

        step.linkSystemLibrary("iupfiledlg");
        step.linkSystemLibrary("iupole");
        step.linkSystemLibrary("iupgl");
        step.linkSystemLibrary("zlib1");
    }

    step.linkSystemLibrary("iupcd");
    step.linkSystemLibrary("iupgl");
    step.linkSystemLibrary("iup_mglplot");
    step.linkSystemLibrary("iup");
    step.linkSystemLibrary("iupcontrols");
    step.linkSystemLibrary("iupimglib");
    step.linkSystemLibrary("iup_plot");
    step.linkSystemLibrary("iuptuio");
    step.linkSystemLibrary("iupglcontrols");
    step.linkSystemLibrary("iupim");
    step.linkSystemLibrary("iup_scintilla");
    step.linkSystemLibrary("iupweb");

    step.addIncludePath("../lib/include");
    step.addPackagePath("iup", "../src/iup.zig");
}

pub fn build(b: *std.build.Builder) void {
    addExample(b, "counter", "1. Counter", "src/counter.zig");
    addExample(b, "tempConv", "2. Temperature Converter", "src/temp_conv.zig");
    addExample(b, "bookFlight", "3. Flight Booker", "src/book_flight.zig");
    addExample(b, "timer", "4. Timer", "src/timer.zig");
    addExample(b, "crud", "5. Crud", "src/crud.zig");
    addExample(b, "circle", "6. Circle Drawer", "src/circle.zig");
    addExample(b, "cells", "7. Cells", "src/cells.zig");

    const mode = b.standardReleaseOptions();
    var main_tests = b.addTest("src/tests.zig");
    main_tests.setBuildMode(mode);
    main_tests.linkLibC();
    try addIupReference(main_tests);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
}

fn addExample(b: *Builder, comptime name: []const u8, comptime description: []const u8, comptime file: []const u8) void {
    const mode = b.standardReleaseOptions();

    const example = b.addExecutable(name, file);
    example.setBuildMode(mode);
    example.linkLibC();
    try addIupReference(example);
    example.install();

    const example_cmd = example.run();
    example_cmd.step.dependOn(b.getInstallStep());

    const example_step = b.step(name, description);
    example_step.dependOn(&example_cmd.step);
}
