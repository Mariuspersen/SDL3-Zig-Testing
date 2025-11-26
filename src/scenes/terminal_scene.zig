const Scene = @import("../scene.zig");
const std = @import("std");

const Error = Scene.Error;

const Self = @This();

const Vars = struct {
    writer: std.fs.File.Writer,
    count: usize,
};

pub fn init(alloc: std.mem.Allocator) !Scene {
    return try .init(
        alloc,
        Vars,
        &.{
            .start = start,
            .loop = loop,
            .stop = stop,
        },
    );
}

fn start(s: *Scene) Error!void {
    const vars: *Vars = @ptrCast(@alignCast(s.vars));
    vars.* = Vars{
        .writer = std.fs.File.stdout().writer(try s.alloc.alloc(u8, 1024)),
        .count = 0,
    };
    const stdout = &vars.writer.interface;
    try stdout.print("Starting...\n", .{});
}

fn loop(s: *Scene) Error!void {
    const vars: *Vars = @ptrCast(@alignCast(s.vars));
    vars.count += 1;
    const stdout = &vars.writer.interface;
    try stdout.print("Looping...\n", .{});
    if (vars.count >= 5) s.looping = false;
}

fn stop(s: *Scene) Error!void {
    const vars: *Vars = @ptrCast(@alignCast(s.vars));
    const stdout = &vars.writer.interface;
    try stdout.print("Stopping...\n", .{});
    try stdout.flush();
    s.alloc.free(vars.writer.interface.buffer);
}
