use std::ffi::c_void;

unsafe extern "C" {
    // The symbol named in the Roc platform's `provides` section.
    fn roc_transform(value: i64) -> i64;

    // All allocation callbacks use the same C allocator.
    fn malloc(size: usize) -> *mut c_void;
    fn realloc(ptr: *mut c_void, size: usize) -> *mut c_void;
    fn free(ptr: *mut c_void);
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn roc_alloc(size: usize, alignment: usize) -> *mut c_void {
    if alignment > 8 {
        std::process::abort();
    }
    let ptr = unsafe { malloc(size.max(1)) };
    if ptr.is_null() {
        std::process::abort();
    }
    ptr
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn roc_realloc(
    ptr: *mut c_void,
    size: usize,
    alignment: usize,
) -> *mut c_void {
    if alignment > 8 {
        std::process::abort();
    }
    let next = unsafe { realloc(ptr, size.max(1)) };
    if next.is_null() {
        std::process::abort();
    }
    next
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn roc_dealloc(ptr: *mut c_void, _alignment: usize) {
    unsafe { free(ptr) };
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn roc_dbg(bytes: *const u8, len: usize) {
    let message = unsafe { std::slice::from_raw_parts(bytes, len) };
    eprintln!("{}", String::from_utf8_lossy(message));
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn roc_crashed(bytes: *const u8, len: usize) {
    unsafe { roc_dbg(bytes, len) };
    std::process::exit(1);
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn roc_expect_failed(bytes: *const u8, len: usize) {
    unsafe { roc_crashed(bytes, len) };
}

fn main() {
    let answer = unsafe { roc_transform(41) };
    println!("{answer}");
    std::process::exit(if answer == 42 { 0 } else { 1 });
}
