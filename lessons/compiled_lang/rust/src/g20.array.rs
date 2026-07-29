fn main() {
    let nicknames = ["bob", "ed", "steve", "ralph", "joe", "deb", "kate"];

    println!("The names are: ");
    for (i, name) in nicknames.iter().enumerate() {
        println!(" nicknames[{i}]={name}");
    }
}
