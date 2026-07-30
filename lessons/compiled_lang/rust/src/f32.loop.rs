// testbox: title="for _ in iter::repeat(()) with break"
use std::io::{self, Write};

fn main() {
    // an infinite for-loop, spun from an infinite iterator instead of a
    //  dedicated loop keyword
    for _ in std::iter::repeat(()) {
        print!("Enter your name (quit to exit): ");
        io::stdout().flush().unwrap();

        let mut line = String::new();
        io::stdin().read_line(&mut line).unwrap();
        let answer = line.trim_end().to_string();

        if answer == "quit" {
            break;
        }

        println!("Hello {}!", answer);
    }
}
