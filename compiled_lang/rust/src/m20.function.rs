fn sort_array<'a>(array: &[&'a str]) -> Vec<&'a str> {
    let mut result = array.to_vec();
    result.sort();
    result
}

fn main() {
    let array = ["bob", "ed", "steve", "ralph", "joe", "deb", "kate"];
    println!("Current names are: {}", array.join(", "));

    let result = sort_array(&array);
    println!("Sorted names are: {}", result.join(", "));
}
