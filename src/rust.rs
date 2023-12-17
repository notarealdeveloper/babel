/// File: lib.rs

#[no_mangle]
pub unsafe extern "C" fn rust_function(x: i32) -> i32 {
    println!("rust_function: got {}", x);
    2*x
}
