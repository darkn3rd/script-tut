use std::io::{self, Read, Write};

fn main() {
    print!("Select an item from the menu.\n\n  1 - Coffee\n  2 - Espresso\n  3 - Latte\n  4 - Machiato\n  5 - Capucino\n  6 - Mocha\n  7 - Tea\n\nMake your selection: ");
    io::stdout().flush().unwrap();

    let mut buf = [0u8; 1];
    io::stdin().read_exact(&mut buf).unwrap();
    let selection = buf[0] as i32 - '0' as i32;

    match selection {
        1 => println!("You selected a Coffee"),
        2 => println!("You selected an Espresso"),
        3 => println!("You selected a Latte"),
        4 => println!("You selected a Machiato"),
        5 => println!("You selected a Capucino"),
        6 => println!("You selected a Mocha"),
        7 => println!("You selected a Tea"),
        _ => println!("You have not entered a valid selection"),
    }
}
