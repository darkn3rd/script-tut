use std::io::{self, Read, Write};

fn main() {
    print!("Input a character: ");
    io::stdout().flush().unwrap();

    let mut buf = [0u8; 1];
    io::stdin().read_exact(&mut buf).unwrap();
    let keypress = buf[0] as char;

    // match's char range patterns are Rust's native multiway pattern
    //  branch - no separate regex needed
    match keypress {
        'A'..='Z' => println!("Uppercase letter"),
        'a'..='z' => println!("Lowercase letter"),
        '0'..='9' => println!("Digit"),
        _ => println!("Punctuation, whitespace, or other"),
    }
}
