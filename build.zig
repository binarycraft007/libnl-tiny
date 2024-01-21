const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const libnl_dep = b.dependency("libnl_tiny", .{});

    const lib = b.addStaticLibrary(.{
        .name = "nl-tiny",
        .target = target,
        .optimize = optimize,
    });
    inline for (libnl_tiny_src) |src| {
        lib.addCSourceFile(.{
            .file = libnl_dep.path(src),
            .flags = &.{},
        });
    }
    lib.linkLibC();
    lib.root_module.addCMacro("_GNU_SOURCE", "");
    lib.addIncludePath(libnl_dep.path("include"));
    lib.installHeadersDirectoryOptions(.{
        .source_dir = libnl_dep.path("include"),
        .install_dir = .header,
        .install_subdir = "",
        .include_extensions = &.{".h"},
    });
    b.installArtifact(lib);

    const lib_unit_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/root.zig" },
        .target = target,
        .optimize = optimize,
    });
    lib_unit_tests.root_module.linkLibrary(lib);

    const run_lib_unit_tests = b.addRunArtifact(lib_unit_tests);
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_lib_unit_tests.step);
}

const libnl_tiny_src = [_][]const u8{
    "attr.c",
    "cache.c",
    "cache_mngt.c",
    "error.c",
    "genl.c",
    "genl_ctrl.c",
    "genl_family.c",
    "genl_mngt.c",
    "handlers.c",
    "msg.c",
    "nl.c",
    "object.c",
    "socket.c",
    "unl.c",
};
