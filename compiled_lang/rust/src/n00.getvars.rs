fn main() {
    // Enumerate the whole process environment as plain "KEY=value" lines -
    //  which well-known names actually show up (USER/HOME/... on POSIX,
    //  USERNAME/USERPROFILE/... on Windows) depends entirely on the host,
    //  so nothing here needs to special-case either platform.
    for (key, value) in std::env::vars() {
        println!("{key}={value}");
    }
}
