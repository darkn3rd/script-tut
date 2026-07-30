use std::env;

fn main() {
    // split_paths splits on this platform's native delimiter (":" on
    //  POSIX, ";" on Windows) automatically, unlike a shell lesson which
    //  has to sniff PATH's own content first to tell which one applies.
    if let Ok(path_var) = env::var("PATH") {
        for entry in env::split_paths(&path_var) {
            println!("{}", entry.display());
        }
    }
}
