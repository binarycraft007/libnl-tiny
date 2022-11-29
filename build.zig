const std = @import("std");
const path = std.fs.path;

pub fn build(b: *std.build.Builder) void {
    const mode = b.standardReleaseOptions();
    const libnl_root = comptime "src";

    const libnl_src = [_][]const u8{
        libnl_root ++ path.sep_str ++ "attr.c",
        libnl_root ++ path.sep_str ++ "cache.c",
        libnl_root ++ path.sep_str ++ "cache_mngt.c",
        libnl_root ++ path.sep_str ++ "error.c",
        libnl_root ++ path.sep_str ++ "genl.c",
        libnl_root ++ path.sep_str ++ "genl_ctrl.c",
        libnl_root ++ path.sep_str ++ "genl_family.c",
        libnl_root ++ path.sep_str ++ "genl_mngt.c",
        libnl_root ++ path.sep_str ++ "handlers.c",
        libnl_root ++ path.sep_str ++ "msg.c",
        libnl_root ++ path.sep_str ++ "nl.c",
        libnl_root ++ path.sep_str ++ "object.c",
        libnl_root ++ path.sep_str ++ "socket.c",
        libnl_root ++ path.sep_str ++ "unl.c",
    };

    const libnl_cflags = [_][]const u8{
        "-Wall",
    };

    const lib = b.addStaticLibrary("nl-tiny", null);
    lib.linkLibC();
    lib.addIncludePath(libnl_root ++ path.sep_str ++ "include");
    lib.addCSourceFiles(&libnl_src, &libnl_cflags);
    lib.setBuildMode(mode);
    lib.install();

    const main_tests = b.addTest("src/main.zig");
    main_tests.setBuildMode(mode);

    const test_step = b.step("test", "Run library tests");
    test_step.dependOn(&main_tests.step);
}
