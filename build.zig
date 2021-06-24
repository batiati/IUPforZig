const std = @import("std");
const Builder = std.build.Builder;
const Pkg = std.build.Pkg;

fn addIupReference(step: *std.build.LibExeObjStep) !void {
    const b = step.builder;

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

        // Workarround for
        // #9002 Find native include and libraries is broken with msvc ABI 
        // https://github.com/ziglang/zig/issues/9002

        step.addLibPath("lib/uwp");
        step.addLibPath("lib/um");
        step.addLibPath("lib/ucrt");

        step.addLibPath("C:\\Program Files (x86)\\Microsoft Visual Studio\\2019\\Community\\VC\\Tools\\MSVC\\14.29.30037\\lib\\x64");


        // Link againts .lib files
        step.addLibPath("lib/win64");
        
        step.linkSystemLibrary("iupfiledlg");
        step.linkSystemLibrary("iupole");
        step.linkSystemLibrary("iupgl");
        step.linkSystemLibrary("zlib1"); 
    }

    // Please visit IUP's download page for your platform
    // https://sourceforge.net/projects/iup/files/3.30/
    //
    // Dependencies for libim and libcd also required
    // https://sourceforge.net/projects/imtoolkit/files/3.15/
    // https://sourceforge.net/projects/canvasdraw/files/5.14/

    step.linkSystemLibrary("ftgl");
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

    // Includes .h
    step.addIncludeDir("lib/include");
}

pub fn build(b: *Builder) !void {
    const mode = b.standardReleaseOptions();

    const lib = b.addStaticLibrary("ziup", "src/iup.zig");
    lib.setBuildMode(mode);
    lib.linkLibC();
    try addIupReference(lib);
    lib.install();

    var main_tests = b.addTest("src/iup.zig");
    main_tests.setBuildMode(mode);
    main_tests.linkLibC();
    try addIupReference(main_tests);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);

    const exe = b.addExecutable("example", "src/notepad_example.zig");
    exe.setBuildMode(mode);
    exe.linkLibC();
    try addIupReference(exe);
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Notepad example app");
    run_step.dependOn(&run_cmd.step);

    const tabs_example = b.addExecutable("tabs", "src/tabs_example.zig");
    tabs_example.setBuildMode(mode);
    tabs_example.linkLibC();
    try addIupReference(tabs_example);
    tabs_example.install();

    const tabs_example_cmd = tabs_example.run();
    tabs_example_cmd.step.dependOn(b.getInstallStep());

    const tabs_example_step = b.step("tabs", "Tabs example app");
    tabs_example_step.dependOn(&tabs_example_cmd.step);


}
