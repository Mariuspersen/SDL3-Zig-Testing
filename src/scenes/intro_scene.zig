const Scene = @import("../scene.zig");
const sdl3 = @import("sdl3");

const std = @import("std");
const TerminalScene = @import("terminal_scene.zig");

const Error = Scene.Error;

const Self = @This();

interface: Scene,

const Vars = struct {
    init_flags: sdl3.InitFlags = .everything,
    fps: usize = 60,
    screen_width: usize = 640,
    screen_height: usize = 480,
    window: sdl3.video.Window = undefined,
    fps_capper: sdl3.extras.FramerateCapper(f32) = .{ .mode = .{ .limited = 60 } },
};

pub fn init(alloc: std.mem.Allocator) !Self {
    return .{
        .interface = try .init(
            alloc,
            Vars,
            &.{
                .start = start,
                .loop = loop,
                .stop = stop,
                .swap = swap,
            },
        ),
    };
}

fn start(s: *Scene) Error!void {
    const vars: *Vars = @ptrCast(@alignCast(s.vars));
    vars.* = Vars{};
    vars.window = try .init("Title", vars.screen_width, vars.screen_height, .{});
    try sdl3.init(vars.init_flags);
}

fn loop(s: *Scene) Error!void {
    const vars: *Vars = @ptrCast(@alignCast(s.vars));
    _ = vars.fps_capper.delay();
    const surface = try vars.window.getSurface();
    try surface.fillRect(null, .{ .value = 0x181818 });
    try vars.window.updateSurface();

    while (sdl3.events.poll()) |event| switch (event) {
        .quit => s.looping = false,
        .terminating => s.looping = false,
        .key_down => |_| {
            try s.vtable.swap(s,try TerminalScene.init(s.alloc));
        },
        else => {},
    };
}

fn stop(s: *Scene) Error!void {
    const vars: *Vars = @ptrCast(@alignCast(s.vars));
    vars.window.deinit();
    sdl3.quit(vars.init_flags);
    s.alloc.destroy(vars);
}

fn swap(s: *Scene, new: Scene) Error!void {
    try s.stop();
    s.vtable = new.vtable;
    s.vars = new.vars;
    try s.start();
}
