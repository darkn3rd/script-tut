use std::env;
use std::process::exit;

fn usage(script_name: &str) -> String {
    format!("\nUsage: {script_name} [-c|-e|-l|-k|-p|-m|-t] [-h|-?]\n\n  -c  Coffee\n  -e  Espresso\n  -l  Latte\n  -k  Machiato\n  -p  Capucino\n  -m  Mocha\n  -t  Tea\n  -h  Display this help message\n  -?  Display this help message\n\n")
}

fn main() {
    // env::args() reports the whole invoked path (e.g. ".\bin\o00.flags.exe"),
    //  not a basename - same as j00.arguments.rs, and unlike a shell
    //  lesson's own `basename "$0"`, since nothing here strips it.
    let all_args: Vec<String> = env::args().collect();
    let script_name = &all_args[0];
    let args = &all_args[1..];

    // Only the first flag is ever examined - equivalent to a single pass
    //  through getopts that returns after the first recognized option.
    match args.first().map(String::as_str) {
        Some("-c") => { println!("You ordered a Coffee."); exit(0); }
        Some("-e") => { println!("You ordered an Espresso."); exit(0); }
        Some("-l") => { println!("You ordered a Latte."); exit(0); }
        Some("-k") => { println!("You ordered a Machiato."); exit(0); }
        Some("-p") => { println!("You ordered a Capucino."); exit(0); }
        Some("-m") => { println!("You ordered a Mocha."); exit(0); }
        Some("-t") => { println!("You ordered a Tea."); exit(0); }
        Some("-h") | Some("-?") => { print!("{}", usage(script_name)); exit(0); }
        _ => { eprint!("{}", usage(script_name)); exit(1); }
    }
}
