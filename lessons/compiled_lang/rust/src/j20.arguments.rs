use std::env;

fn main() {
    let args: Vec<String> = env::args().skip(1).collect();

    println!("The arguments passed are (reverse order):");
    for i in (0..args.len()).rev() {
        println!(" item {}: {}", i + 1, args[i]);
    }
}
