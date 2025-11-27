const Scene = @This();
const std = @import("std");

looping: bool = true,
alloc: std.mem.Allocator,
vars: *anyopaque,
vtable: *const VTable,

pub fn init(alloc: std.mem.Allocator, T: type, vtable: *const VTable) !Scene {
    return .{
        .alloc = alloc,
        .vars = @ptrCast(try alloc.create(T)),
        .vtable = vtable,
    };
}

pub const VTable = struct {
    start: *const fn (self: *Scene) Error!void,
    loop: *const fn (self: *Scene) Error!void,
    stop: *const fn(self: *Scene) Error!void,
    swap: *const fn(self: *Scene, new: Scene) Error!void = defaultSwap,
};

pub const Error = error{
    LoopError,
    InitError,
    DeinitError,
    SdlError,
    WriteFailed,
    ReadFailed,
    OutOfMemory,
    NotImplemented,
    EndOfStream,
};

pub fn start(self: *Scene) Error!void {
    try self.vtable.start(self);
}

pub fn loop(self: *Scene) Error!void {
    while (self.looping) try self.vtable.loop(self);
}

pub fn stop(self: *Scene) Error!void {
    try self.vtable.stop(self);
}

pub fn swap(self: *Scene, new: Scene) Error!void {
    try self.vtable.swap(self,new);
}

fn defaultSwap(s: *Scene, new: Scene) Error!void {
    try s.stop();
    s.vtable = new.vtable;
    s.vars = new.vars;
    try s.start();
}