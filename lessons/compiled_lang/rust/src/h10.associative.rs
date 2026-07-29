use std::collections::HashMap;

fn main() {
    // initialize map with key/value pairs
    let mut ages: HashMap<&str, i32> = HashMap::from([
        ("bob", 34), ("ed", 58), ("steve", 32), ("ralph", 23),
    ]);
    // append another set of key/value pairs into map
    let more: HashMap<&str, i32> = HashMap::from([("deb", 46), ("kate", 19)]);
    ages.extend(more);

    // iterate through map by keys, print key/value pairs
    println!("The ages are: ");
    for (name, age) in &ages {
        println!(" ages[{}]={}", name, age);
    }
}
