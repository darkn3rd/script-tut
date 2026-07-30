use std::env;

fn main() {
    let args: Vec<String> = env::args().skip(1).collect();

    println!("The arguments passed are:");
    for (i, arg) in args.iter().enumerate() {
        println!(" item {}: {arg}", i + 1);
    }
}
