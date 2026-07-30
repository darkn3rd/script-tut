// testbox: title="loop {} with continue"
use std::io::{self, Write};

fn main() {
    loop {
        print!("Enter your name (quit to exit): ");
        io::stdout().flush().unwrap();

        let mut line = String::new();
        io::stdin().read_line(&mut line).unwrap();
        let answer = line.trim_end().to_string();

        if answer.trim().is_empty() {
            continue;
        }

        if answer == "quit" {
            break;
        }

        println!("Hello {}!", answer);
    }
}
