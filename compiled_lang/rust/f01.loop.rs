// testbox: title="Iterator::for_each() with closure"
use std::fs;

fn main() {
    let mut entries: Vec<_> = fs::read_dir("dirtest").unwrap().map(|e| e.unwrap()).collect();
    entries.sort_by_key(|e| e.file_name());

    // Iterator::for_each() with a closure
    entries.iter().for_each(|entry| {
        let name = entry.file_name().to_string_lossy().to_string();
        if entry.path().is_dir() {
            println!("{} is a directory", name);
        } else {
            println!("{} is not a directory", name);
        }
    });
}
