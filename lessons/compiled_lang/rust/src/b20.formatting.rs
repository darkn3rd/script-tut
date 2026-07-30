fn main() {
    let number = 5;
    let character = 'a';
    let text = "This is a string";

    // Positional format arguments - Rust's closest std equivalent to
    //  printf's ordinal %1$d-style verbs, each `{N}` bound to an argument
    //  index rather than a captured variable name (contrast with b10's
    //  "{number}" interpolation).
    print!("Number is {0}.\nCharacter is '{1}'.\nString is \"{2}\".\n", number, character, text);
}
