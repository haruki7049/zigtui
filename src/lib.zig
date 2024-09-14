pub fn init() !void {
}

pub fn shutdown() !void {
}

test "initialize" {
    try init();
    try shutdown();
}
