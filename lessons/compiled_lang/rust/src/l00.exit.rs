use std::env;
use std::process;

const EX_USAGE: i32 = 64;
const EX_OK: i32 = 0;

fn usage_message(script_name: &str) -> ! {
    eprintln!();
    eprintln!("You need to enter one or more numbers:");
    eprintln!();
    eprintln!("   Usage: {script_name} [num1] [num2] [num3]...");
    eprintln!();
    process::exit(EX_USAGE);
}

fn add_nums(numbers: &[String]) -> ! {
    let mut sum = 0;
    for num in numbers {
        sum += num.parse::<i32>().unwrap();
    }
    println!("The summation is: {sum}.");
    process::exit(EX_OK);
}

fn main() {
    let all_args: Vec<String> = env::args().collect();
    let script_name = &all_args[0];
    let args = &all_args[1..];

    if args.is_empty() {
        usage_message(script_name);
    } else {
        add_nums(args);
    }
}
