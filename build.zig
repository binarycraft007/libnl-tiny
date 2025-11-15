const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const upstream = b.dependency("upstream", .{});

    const lib = b.addLibrary(.{
        .name = "nl-tiny",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .link_libc = true,
        }),
    });
    lib.addCSourceFiles(.{
        .root = upstream.path("."),
        .files = &libnl_tiny_src,
    });
    lib.root_module.addCMacro("_GNU_SOURCE", "");
    lib.addIncludePath(upstream.path("include"));
    lib.installHeadersDirectory(upstream.path("include"), "", .{});
    b.installArtifact(lib);
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
