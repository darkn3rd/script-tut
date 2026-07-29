use std::env;

fn main() {
    let all_args: Vec<String> = env::args().collect();
    let script_name = &all_args[0];
    let args = &all_args[1..];

    if args.len() != 2 {
        eprintln!();
        eprintln!("You need to enter two numbers:");
        eprintln!();
        eprintln!("   Usage: {script_name} [num1] [num2]");
        eprintln!();
    } else {
        let num1: i32 = args[0].parse().unwrap();
        let num2: i32 = args[1].parse().unwrap();
        println!("The sum of {} and {} is: {}.", args[0], args[1], num1 + num2);
    }
}
