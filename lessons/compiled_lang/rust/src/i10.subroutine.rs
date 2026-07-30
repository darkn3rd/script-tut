// mutable statics can only be touched inside `unsafe` - Rust's
//  compiler-enforced stand-in for Python's explicit `global` keyword.
static mut POND: i32 = 500;
static mut CAPTURED: i32 = 0;

fn fish() {
    unsafe {
        POND -= 150;
        CAPTURED += 150;
    }
}

fn main() {
    let pond = unsafe { POND };
    println!("We have {pond} in this pond.");

    fish();
    let pond = unsafe { POND };
    println!("Fishing from the main pond... We now have {pond} in the main pond.");

    fish();
    let pond = unsafe { POND };
    println!("Fishing from the main pond... We now have {pond} in the main pond.");

    fish();
    let pond = unsafe { POND };
    println!("Fishing from the main pond... We now have {pond} in the main pond.");

    let captured = unsafe { CAPTURED };
    println!("We now have a total of {captured} fish captured");
}
