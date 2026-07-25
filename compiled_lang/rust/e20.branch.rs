use std::io::{self, Write};

fn main() {
    print!("Input a number: ");
    io::stdout().flush().unwrap();

    let mut line = String::new();
    io::stdin().read_line(&mut line).unwrap();
    let number: i32 = line.trim_end().parse().unwrap();

    if number > 0 {
        println!("Number is greater than 0");
    } else if number < 0 {
        println!("Number is less than 0");
    } else {
        println!("Number is 0");
    }
}
