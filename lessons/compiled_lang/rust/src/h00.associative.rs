use std::collections::HashMap;

fn main() {
    // create empty map
    let mut ages: HashMap<&str, i32> = HashMap::new();
    // insert one element at a time
    ages.insert("bob", 34);
    ages.insert("ed", 58);
    ages.insert("steve", 32);
    ages.insert("ralph", 23);
    ages.insert("deb", 46);
    ages.insert("kate", 19);

    // enumerate and print keys and values
    let keys: Vec<String> = ages.keys().map(|k| k.to_string()).collect();
    let values: Vec<String> = ages.values().map(|v| v.to_string()).collect();
    println!("Keys (names):  {}", keys.join(", "));
    println!("Values (ages): {}", values.join(", "));
}
