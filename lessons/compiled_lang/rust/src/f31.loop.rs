// testbox: title="while true with break"
use std::io::{self, Write};

// rustc's built-in `while_true` lint pushes toward `loop {}` (see
//  f30.loop.rs) - suppressed here since this file exists specifically to
//  show the literal "while true" spelling other languages use
#[allow(while_true)]
fn main() {
    while true {
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
