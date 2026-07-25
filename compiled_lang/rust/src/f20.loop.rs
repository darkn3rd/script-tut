// testbox: title="while loop"
use std::io::{self, Write};

fn main() {
    let mut answer = String::new();
    while answer != "quit" {
        print!("Enter your name (quit to Exit): ");
        io::stdout().flush().unwrap();

        let mut line = String::new();
        io::stdin().read_line(&mut line).unwrap();
        answer = line.trim_end().to_string();

        if answer != "quit" {
            println!("Hello {}!", answer);
        }
    }
}
