const Scene = @This();

looping: bool = true,
next: ?*Scene = null,
vtable: *const VTable,

pub const VTable = struct {
    init: *const fn (self: *Scene) Error!void,
    loop: *const fn (self: *Scene) Error!void,
    deinit: *const fn(self: *Scene) Error!void,
};

pub const Error = error{
    LoopError,
    InitError,
    DeinitError,
    SdlError,
};

pub fn init(self: *Scene) Error!void {
    try self.vtable.init(self);
}

pub fn loop(self: *Scene) Error!void {
    while (self.looping) try self.vtable.loop(self);
}

pub fn deinit(self: *Scene) Error!void {
    try self.vtable.deinit(self);
}

pub fn switchScene(_: *Scene) Error!void {
    return error.Unimplemented;
}