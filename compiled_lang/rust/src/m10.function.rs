fn capitalize(s: &str) -> String {
    s.to_uppercase()
}

fn main() {
    let s = "ibm";
    println!("The current string is: \"{s}\".");

    let result = capitalize(s);
    println!("The capitalized string is: \"{result}\".");
}
