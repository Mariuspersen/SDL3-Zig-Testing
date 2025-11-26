const std = @import("std");
const Intro = @import("scenes/intro_scene.zig");
pub fn main() !void {
    var Manager = try Intro.init(std.heap.page_allocator);
    var scene = &Manager.interface;
    try scene.start();
    try scene.loop();
    try scene.stop();
}
