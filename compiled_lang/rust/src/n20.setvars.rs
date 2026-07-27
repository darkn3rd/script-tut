use std::collections::BTreeMap;
use std::env;
use std::fs;
use std::io;
use std::time::{SystemTime, UNIX_EPOCH};

fn main() {
    // BTreeMap, not a hash map - it keeps keys in sorted order for free,
    //  which is exactly the order the joined MY_ORDERS value needs.
    let mut drinks: BTreeMap<&str, i32> = BTreeMap::new();
    for key in ["Capucino", "Coffee", "Espresso", "Latte", "Machiato", "Mocha", "Tea"] {
        drinks.insert(key, 0);
    }

    let args: Vec<String> = env::args().skip(1).collect();
    if args.is_empty() {
        // No RNG in std - a small xorshift seeded from the system clock
        //  stands in for `$RANDOM`. The test harness always supplies
        //  fixed "Key:Qty" arguments, so this branch never actually runs
        //  under test; it only needs to produce some value in 0-2.
        let nanos = SystemTime::now().duration_since(UNIX_EPOCH).unwrap().subsec_nanos();
        let mut state = nanos.max(1);
        for value in drinks.values_mut() {
            state ^= state << 13;
            state ^= state >> 17;
            state ^= state << 5;
            *value = (state % 3) as i32;
        }
    } else {
        for pair in &args {
            if let Some((key, qty)) = pair.split_once(':') {
                if let Ok(qty) = qty.parse::<i32>() {
                    if let Some(slot) = drinks.get_mut(key) {
                        *slot = qty;
                    }
                }
            }
        }
    }

    let mut parts: Vec<String> = Vec::new();
    for (key, qty) in &drinks {
        if *qty != 0 {
            parts.push(format!("{key}:{qty}"));
        }
    }
    let order = parts.join(",");

    // set_var is `unsafe` on this rustc: mutating the process environment
    //  isn't thread-safe in general (a concurrent getenv elsewhere could
    //  race it) - the same reasoning as i10.subroutine.rs's `unsafe`
    //  around mutable-static access, just enforced by the standard
    //  library instead of the borrow checker. This program is
    //  single-threaded, so it's safe in practice.
    unsafe {
        env::set_var("MY_ORDERS", &order);
    }

    // Dump the whole environment - plain "KEY=value" lines, same as
    //  n00.getvars.rs - to a well-known file for an external observer to
    //  read while this process is paused below. Built after set_var so
    //  the dump reflects the just-set MY_ORDERS, deleted again just
    //  before exit.
    let mut dump = String::new();
    for (key, value) in env::vars() {
        dump.push_str(&format!("{key}={value}\n"));
    }
    fs::write("dump_env.out", dump).unwrap();

    // No explicit flush needed here (unlike d10.input.rs's prompt) -
    //  confirmed empirically: Rust's Stdout is always a LineWriter that
    //  flushes on '\n' regardless of whether the destination is a tty or
    //  a pipe, unlike C's stdio - so println!'s own trailing newline
    //  already pushes this line through before the blocking read below.
    println!("MY_ORDERS set, Hit Return to continue");

    let mut discard = String::new();
    io::stdin().read_line(&mut discard).unwrap();

    fs::remove_file("dump_env.out").ok();
}
