// testbox: title="manual iterator (while let Some(...) = iter.next())"
use std::fs;

fn main() {
    let mut entries: Vec<_> = fs::read_dir("dirtest").unwrap().map(|e| e.unwrap()).collect();
    entries.sort_by_key(|e| e.file_name());

    // step through the iterator protocol a for-in loop desugars to
    let mut iter = entries.iter();
    while let Some(entry) = iter.next() {
        let name = entry.file_name().to_string_lossy().to_string();
        if entry.path().is_dir() {
            println!("{} is a directory", name);
        } else {
            println!("{} is not a directory", name);
        }
    }
}
