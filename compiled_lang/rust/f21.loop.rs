// testbox: title="while let with an Option-returning helper"
use std::io::{self, BufRead, Write};

// prompts, reads one line, and returns it unless the user wants to quit -
//  so the while-let below only keeps looping while there's a real answer
fn next_answer(lines: &mut impl Iterator<Item = io::Result<String>>) -> Option<String> {
    print!("Enter your name (quit to Exit): ");
    io::stdout().flush().unwrap();

    let answer = lines.next()?.unwrap();
    if answer == "quit" {
        None
    } else {
        Some(answer)
    }
}

fn main() {
    let stdin = io::stdin();
    let mut lines = stdin.lock().lines();

    while let Some(answer) = next_answer(&mut lines) {
        println!("Hello {}!", answer);
    }
}
