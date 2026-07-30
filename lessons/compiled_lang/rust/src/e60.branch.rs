use std::io::{self, Read, Write};

fn main() {
    print!("Input a character: ");
    io::stdout().flush().unwrap();

    let mut buf = [0u8; 1];
    io::stdin().read_exact(&mut buf).unwrap();
    let keypress = buf[0] as char;

    // the standard library has no regex (that's an external crate, and
    //  these lessons stay dependency-free) - matches!() with a char
    //  range pattern is the native stand-in for a single pattern test
    if matches!(keypress, 'A'..='Z') {
        println!("Uppercase letter");
    } else if matches!(keypress, 'a'..='z') {
        println!("Lowercase letter");
    } else if matches!(keypress, '0'..='9') {
        println!("Digit");
    } else {
        println!("Punctuation, whitespace, or other");
    }
}
