const std = @import("std");
const Intro = @import("scenes/intro_scene.zig");
pub fn main() !void {
    var intro = try Intro.init();
    const scene = &intro.interface;
    try scene.init();
    try scene.loop();
    try scene.deinit();
}
