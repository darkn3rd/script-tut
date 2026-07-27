use std::env;
use std::process::exit;

fn usage(script_name: &str) -> String {
    format!("\nUsage: {script_name} [-c] [-e] [-l] [-k] [-p] [-m] [-t] [-h|-?]\n\n  -c  Coffee\n  -e  Espresso\n  -l  Latte\n  -k  Machiato\n  -p  Capucino\n  -m  Mocha\n  -t  Tea\n  -h  Display this help message\n  -?  Display this help message\n\n")
}

fn main() {
    let all_args: Vec<String> = env::args().collect();
    let script_name = &all_args[0];
    let args = &all_args[1..];

    // Manual args() iteration naturally preserves the command-line order,
    //  unlike a hash/map-backed collection - needed since the expected
    //  output lists orders in exactly the order given.
    let mut orders: Vec<&str> = Vec::new();
    for arg in args {
        match arg.as_str() {
            "-c" => orders.push("coffee"),
            "-e" => orders.push("espresso"),
            "-l" => orders.push("latte"),
            "-k" => orders.push("macchiato"),
            "-p" => orders.push("capucino"),
            "-m" => orders.push("mocha"),
            "-t" => orders.push("tea"),
            "-h" | "-?" => { print!("{}", usage(script_name)); exit(0); }
            _ => {}
        }
    }

    if orders.is_empty() {
        eprint!("{}", usage(script_name));
        exit(1);
    }

    println!();
    println!("You ordered: ");
    for drink in orders {
        println!("* {drink}");
    }
}
