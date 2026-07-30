use std::io::{self, Write};

fn main() {
    print!("Would you like a toast? [Yes/No]: ");
    io::stdout().flush().unwrap();

    let mut response = String::new();
    io::stdin().read_line(&mut response).unwrap();
    let response = response.trim_end();

    // Rust has no `?:` operator - if/else is itself an expression, which
    //  is how Rust normally replaces a ternary
    let message = if response == "Yes" { "That's great!" } else { "How about a muffin?" };

    println!("{}", message);
}
