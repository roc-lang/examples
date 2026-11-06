const std = @import("std");

// Roc exports this function using the C ABI, regardless of the host language.
extern fn roc_transform(value: i64) i64;

// Use libc so allocation and reallocation share the same allocator.
extern "c" fn malloc(size: usize) ?*anyopaque;
extern "c" fn realloc(ptr: ?*anyopaque, size: usize) ?*anyopaque;
extern "c" fn free(ptr: ?*anyopaque) void;
extern "c" fn printf(format: [*:0]const u8, ...) c_int;

export fn roc_alloc(size: usize, alignment: usize) ?*anyopaque {
    if (alignment > 8) std.process.abort();
    return malloc(@max(size, 1)) orelse std.process.abort();
}

export fn roc_realloc(ptr: ?*anyopaque, size: usize, alignment: usize) ?*anyopaque {
    if (alignment > 8) std.process.abort();
    return realloc(ptr, @max(size, 1)) orelse std.process.abort();
}

export fn roc_dealloc(ptr: ?*anyopaque, alignment: usize) void {
    _ = alignment;
    free(ptr);
}

export fn roc_dbg(bytes: [*]const u8, len: usize) void {
    std.debug.print("{s}\n", .{bytes[0..len]});
}

export fn roc_crashed(bytes: [*]const u8, len: usize) noreturn {
    roc_dbg(bytes, len);
    std.process.exit(1);
}

export fn roc_expect_failed(bytes: [*]const u8, len: usize) void {
    roc_crashed(bytes, len);
}

pub fn main() u8 {
    const answer = roc_transform(41);
    _ = printf("%lld\n", @as(c_longlong, answer));
    return if (answer == 42) 0 else 1;
}
