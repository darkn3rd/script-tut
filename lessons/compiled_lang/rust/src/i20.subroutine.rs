const POND: i32 = 500; // never mutated - fish() only touches its own local copy

static mut CAPTURED: i32 = 0;

fn fish() {
    let local_pond = POND - 150; // never touches POND, and never leaves this scope
    let _ = local_pond;
    unsafe {
        CAPTURED += 150;
    }
}

fn main() {
    println!("We have {POND} in this pond.");

    fish();
    println!("Fishing from a local pond... We now have {POND} in the main pond.");

    fish();
    println!("Fishing from a local pond... We now have {POND} in the main pond.");

    fish();
    println!("Fishing from a local pond... We now have {POND} in the main pond.");

    let captured = unsafe { CAPTURED };
    println!("We now have a total of {captured} fish captured");
}
