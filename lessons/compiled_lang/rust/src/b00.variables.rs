fn main() {
    let number = 5;
    let character = 'a';
    let text = "This is a string";

    let number_str = number.to_string();
    let character_str = character.to_string();

    let output = "Number is ".to_string()
        + &number_str + ".\n"
        + "Character is '" + &character_str + "'.\n"
        + "String is \"" + text + "\".\n";

    print!("{output}");
}
