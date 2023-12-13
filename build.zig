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
    lib.linkLibC();
    lib.link_gc_sections = false;
    lib.defineCMacro("_GNU_SOURCE", null);
    inline for (libnl_tiny_src) |src| {
        lib.addCSourceFile(.{
            .file = libnl_dep.path(src),
            .flags = &.{},
        });
    }
    lib.addIncludePath(libnl_dep.path("include"));
    lib.installHeadersDirectory(libnl_dep.path("include").getPath(b), "");
    b.installArtifact(lib);

    const lib_unit_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/root.zig" },
        .target = target,
        .optimize = optimize,
    });
    lib_unit_tests.linkLibrary(lib);

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
