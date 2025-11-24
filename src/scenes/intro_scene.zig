const Scene = @import("../scene.zig");
const sdl3 = @import("sdl3");

const Error = Scene.Error;

const Self = @This();

interface: Scene,
init_flags: sdl3.InitFlags = .everything,
fps: usize = 60,
screen_width: usize = 640,
screen_height: usize = 480,
window: sdl3.video.Window = undefined,
fps_capper: sdl3.extras.FramerateCapper(f32) = undefined,

pub fn init() !Self {
    return .{ .interface = .{
        .vtable = &.{
            .init = start,
            .loop = loop,
            .deinit = stop,
        },
    } };
}

fn start(s: *Scene) Error!void {
    const self: *Self = @fieldParentPtr("interface", s);
    try sdl3.init(self.init_flags);
    self.window = try sdl3.video.Window.init(
        "Hello SDL3",
        self.screen_width,
        self.screen_height,
        .{},
    );
    self.fps_capper = .{ .mode = .{ .limited = self.fps } };
}

fn loop(s: *Scene) Error!void {
    const self: *Self = @fieldParentPtr("interface", s);
    _ = self.fps_capper.delay();
    const surface = try self.window.getSurface();
    try surface.fillRect(null, .{ .value = 0x181818 });
    try self.window.updateSurface();

    while (sdl3.events.poll()) |event| switch (event) {
        .quit => s.looping = false,
        .terminating => s.looping = false,
        else => {},
    };
}

fn stop(s: *Scene) Error!void {
    const self: *Self = @fieldParentPtr("interface", s);

    self.window.deinit();
    sdl3.quit(self.init_flags);
}
