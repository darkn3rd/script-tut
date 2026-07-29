// testbox: title="indexed for-in over a Range"
use std::fs;

fn main() {
    let mut entries: Vec<_> = fs::read_dir("dirtest").unwrap().map(|e| e.unwrap()).collect();
    entries.sort_by_key(|e| e.file_name());

    // indexed access - for-in over a Range, indexing into the Vec
    for i in 0..entries.len() {
        let entry = &entries[i];
        let name = entry.file_name().to_string_lossy().to_string();
        if entry.path().is_dir() {
            println!("{} is a directory", name);
        } else {
            println!("{} is not a directory", name);
        }
    }
}
