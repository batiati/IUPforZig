const std = @import("std");
const Builder = std.build.Builder;
const Pkg = std.build.Pkg;

const iup_libs_path = "lib/iup";
const cd_libs_path = "lib/cd";
const im_libs_path = "lib/im";

fn addIupReference(b: *std.build.Builder, artifact: *std.build.LibExeObjStep) !void {
    artifact.addIncludePath(.{
        .path = iup_libs_path ++ "/include",
    });

    const iup_libs = .{
        "iupcd",    "iupgl",         "iup_mglplot",
        "iup",      "iupcontrols",   "iupimglib",
        "iup_plot", "iuptuio",       "iupglcontrols",
        "iupim",    "iup_scintilla",
    };

    inline for (iup_libs) |lib| {
        artifact.linkSystemLibrary(lib);
    }

    if (artifact.target.isWindows()) {
        artifact.addLibraryPath(.{ .path = iup_libs_path });
        artifact.addLibraryPath(.{ .path = cd_libs_path });

        var copy_libs = CopyLibrariesStep.create(b, artifact);
        artifact.step.dependOn(&copy_libs.step);

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
    const mode = b.standardOptimizeOption(.{});

    var main_tests = b.addTest(
        .{
            .root_source_file = .{ .path = "src/iup.zig" },
            .optimize = mode,
        },
    );
    main_tests.linkLibC();
    try addIupReference(b, main_tests);

    const test_step = b.step("test", "Run bindings tests");
    const main_test_cmd = b.addRunArtifact(main_tests);
    main_test_cmd.step.dependOn(&b.addInstallArtifact(main_tests, .{}).step);
    test_step.dependOn(&main_test_cmd.step);

    var @"7gui_test" = b.addTest(
        .{
            .name = "7gui_test",
            .root_source_file = .{ .path = "src/7gui/tests.zig" },
            .optimize = mode,
            .main_pkg_path = .{ .path = "src" },
            .link_libc = true,
        },
    );
    try addIupReference(b, @"7gui_test");

    const @"7gui_test_step" = b.step("7gui_test", "7GUI demo tests");
    const @"7gui_test_cmd" = b.addRunArtifact(@"7gui_test");
    @"7gui_test_cmd".step.dependOn(&b.addInstallArtifact(@"7gui_test", .{}).step);
    @"7gui_test_step".dependOn(&@"7gui_test".step);

    try addExample(b, "run", "IUP notepad example", "src/notepad_example.zig", mode);
    try addExample(b, "tabs", "IUP tabs example", "src/tabs_example.zig", mode);
    try addExample(b, "button", "IUP buttons example", "src/button_example.zig", mode);
    try addExample(b, "image", "IUP image example", "src/image_example.zig", mode);
    try addExample(b, "list", "IUP list example", "src/list_example.zig", mode);
    try addExample(b, "tree", "IUP tree example", "src/tree_example.zig", mode);
    try addExample(b, "mdi", "IUP mdi example", "src/mdi_example.zig", mode);
    try addExample(b, "gauge", "IUP gauge example", "src/gauge_example.zig", mode);

    try addExample(b, "counter", "7GUI Counter", "src/7gui/counter.zig", mode);
    try addExample(b, "tempConv", "7GUI Temperature Converter", "src/7gui/temp_conv.zig", mode);
    try addExample(b, "bookFlight", "7GUI Flight Booker", "src/7gui/book_flight.zig", mode);
    try addExample(b, "timer", "7GUI Timer", "src/7gui/timer.zig", mode);
    try addExample(b, "crud", "7GUI Crud", "src/7gui/crud.zig", mode);
    try addExample(b, "circle", "7GUI Circle Drawer", "src/7gui/circle.zig", mode);
    try addExample(b, "cells", "7GUI Cells", "src/7gui/cells.zig", mode);
}

fn addExample(b: *Builder, comptime name: []const u8, comptime description: []const u8, comptime file: []const u8, mode: std.builtin.OptimizeMode) !void {
    const example = b.addExecutable(
        .{
            .name = name,
            .optimize = mode,
            .root_source_file = .{ .path = file },
            .main_pkg_path = .{ .path = "src" },
            .link_libc = true,
        },
    );
    try addIupReference(b, example);

    const example_cmd = b.addRunArtifact(example);
    example_cmd.step.dependOn(&b.addInstallArtifact(example, .{}).step);

    const example_step = b.step(name, description);
    example_step.dependOn(&example_cmd.step);
}

const CopyLibrariesStep = struct {
    const Self = @This();
    builder: *std.build.Builder,
    step: std.build.Step,
    artifact: *std.build.LibExeObjStep,

    pub fn create(builder: *std.build.Builder, artifact: *std.build.LibExeObjStep) *Self {
        var self = builder.allocator.create(Self) catch unreachable;
        self.* = .{
            .builder = builder,
            .step = std.build.Step.init(.{
                .id = .custom,
                .name = "Copy shared libraries",
                .owner = builder,
                .makeFn = &make,
            }),
            .artifact = artifact,
        };
        return self;
    }

    fn make(step: *std.build.Step, progress: *std.Progress.Node) !void {
        _ = progress;
        const self = @fieldParentPtr(Self, "step", step);
        const full_dest_path = self.builder.getInstallPath(.bin, "");

        var cwd = std.fs.cwd();
        defer cwd.close();

        inline for (.{ iup_libs_path, cd_libs_path, im_libs_path }) |libs_path| {
            const full_src_dir = self.builder.pathFromRoot(libs_path);
            var src_dir = try cwd.openIterableDir(full_src_dir, .{});
            defer src_dir.close();

            var dest_dir = try cwd.openIterableDir(full_dest_path, .{});
            defer dest_dir.close();

            var it = src_dir.iterate();
            while (try it.next()) |entry| {
                const extension = if (self.artifact.target.isWindows()) ".dll" else ".so";
                if (!std.ascii.endsWithIgnoreCase(entry.name, extension)) continue;

                _ = try std.fs.Dir.updateFile(src_dir.dir, entry.name, dest_dir.dir, entry.name, .{});
            }
        }
    }
};
