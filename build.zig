const std = @import("std");

const Build = std.Build;
pub fn build(b: *Build) !void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    
    const sdl3 = b.dependency("sdl3", .{
        .target = target,
        .optimize = optimize,
    });

    const exe = b.addExecutable(.{
        .name = "ZDL",
        .root_module = b.addModule("ZDL", .{
            .root_source_file = b.path("src/main.zig"),
            .optimize = optimize,
            .target = target,
        })
    });
    exe.root_module.addImport("sdl3", sdl3.module("sdl3"));
    b.installArtifact(exe);
}