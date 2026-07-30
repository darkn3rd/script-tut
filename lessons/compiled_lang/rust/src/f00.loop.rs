// testbox: title="for-in loop"
use std::fs;

fn main() {
    // read_dir()'s order isn't guaranteed by the filesystem, so sort by
    //  name first
    let mut entries: Vec<_> = fs::read_dir("dirtest").unwrap().map(|e| e.unwrap()).collect();
    entries.sort_by_key(|e| e.file_name());

    // for-in loop - the only "for" form Rust has
    for entry in &entries {
        let name = entry.file_name().to_string_lossy().to_string();
        if entry.path().is_dir() {
            println!("{} is a directory", name);
        } else {
            println!("{} is not a directory", name);
        }
    }
}
