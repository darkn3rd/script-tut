use std::io::{self, Read, Write};

fn main() {
    print!("Input a character: ");
    io::stdout().flush().unwrap();

    // Exactly one byte, not a whole line - the piped input carries a
    //  trailing newline (see d00.input.rs's read_line), which a
    //  single-character read must leave unconsumed on the stream rather
    //  than accidentally capturing.
    let mut buf = [0u8; 1];
    io::stdin().read_exact(&mut buf).unwrap();
    let character = buf[0] as char;

    println!("You entered: >>|{character}|<<.");
}
