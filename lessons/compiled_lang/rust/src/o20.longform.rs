use std::env;
use std::process::exit;

// Rust's std has nothing resembling getopts's long-option support, and no
//  way to declare a flag that optionally consumes a following value - so,
//  like the bash/go references, this is parsed entirely by hand: each
//  argument is checked against both its long and short spelling, and the
//  next argument is consumed as that flag's quantity.
fn usage(script_name: &str) -> String {
    format!("\nUsage: {script_name} [--coffee|-c N] [--espresso|-e N] [--latte|-l N] [--macchiato|-k N] [--capucino|-p N] [--mocha|-m N] [--tea|-t N] [--help|-h|-?]\n\n  --coffee,    -c N  Coffee\n  --espresso,  -e N  Espresso\n  --latte,     -l N  Latte\n  --macchiato, -k N  Machiato\n  --capucino,  -p N  Capucino\n  --mocha,     -m N  Mocha\n  --tea,       -t N  Tea\n  --help,      -h    Display this help message\n  -?                 Display this help message\n\n")
}

fn main() {
    let all_args: Vec<String> = env::args().collect();
    let script_name = &all_args[0];
    let args = &all_args[1..];

    let mut names: Vec<&str> = Vec::new();
    let mut counts: Vec<&str> = Vec::new();

    let mut i = 0;
    while i < args.len() {
        match args[i].as_str() {
            "--coffee" | "-c"      => { names.push("coffee");    counts.push(&args[i + 1]); i += 2; }
            "--espresso" | "-e"    => { names.push("espresso");  counts.push(&args[i + 1]); i += 2; }
            "--latte" | "-l"       => { names.push("latte");     counts.push(&args[i + 1]); i += 2; }
            "--macchiato" | "-k"   => { names.push("macchiato"); counts.push(&args[i + 1]); i += 2; }
            "--capucino" | "-p"    => { names.push("capucino");  counts.push(&args[i + 1]); i += 2; }
            "--mocha" | "-m"       => { names.push("mocha");     counts.push(&args[i + 1]); i += 2; }
            "--tea" | "-t"         => { names.push("tea");       counts.push(&args[i + 1]); i += 2; }
            "--help" | "-h" | "-?" => { print!("{}", usage(script_name)); exit(0); }
            _ => { eprint!("{}", usage(script_name)); exit(1); }
        }
    }

    if names.is_empty() {
        eprint!("{}", usage(script_name));
        exit(1);
    }

    println!();
    println!("You ordered: ");
    for (name, count) in names.iter().zip(counts.iter()) {
        let qty: i32 = count.parse().unwrap_or(0);
        // Build the base label, then conditionally pluralize - only when
        //  the quantity isn't exactly 1 (matching o20.longform.bash /
        //  o20.longform.go's own established convention).
        let label = if qty == 1 { name.to_string() } else { format!("{name}s") };
        println!("* {count} {label}");
    }
}
