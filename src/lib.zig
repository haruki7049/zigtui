const std = @import("std");
const fs = std.fs;
const errors = @import("./errors.zig");

pub fn init() !void {
}

pub fn shutdown() void {
}

test "initialize" {
    try init();
    defer shutdown();
}
