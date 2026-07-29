use std::io::{self, Write};

fn main() {
    print!("Would you like a toast? [Yes/No]: ");
    io::stdout().flush().unwrap();

    let mut response = String::new();
    io::stdin().read_line(&mut response).unwrap();
    let response = response.trim_end();

    let message;
    if response == "Yes" {
        message = "That's great!";
    } else {
        message = "How about a muffin?";
    }

    println!("{}", message);
}
