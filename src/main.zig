const std = @import("std");
const Intro = @import("scenes/intro_scene.zig");
pub fn main() !void {
    var Manager = try Intro.init(std.heap.page_allocator);
    try Manager.start();
    try Manager.loop();
    try Manager.stop();
}
