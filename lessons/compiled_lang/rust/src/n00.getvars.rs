use std::env;
use std::process::Command;

// Enumerate a fixed set of well-known environment variables, printing
// "NAME=value" for each. USER, TMPDIR, and HOSTNAME aren't reliably set
// as actual environment entries on every POSIX host (confirmed
// directly: missing on GitHub Actions' ubuntu-latest runners) - fall
// back to a portable equivalent for each so this stays reliable
// anywhere, matching lessons/shell_scripts/bash/scripts/n00.getvars.bash's own
// fallback approach. USERNAME/USERPROFILE/TEMP/COMPUTERNAME are
// Windows-only concepts with no POSIX equivalent - printed only when
// actually present.
//
// std has no API for "current username" or "hostname" (no libc crate
// allowed here - see ../README.md, plain rustc only), so those two
// shell out to `whoami`/`hostname` - real, standalone commands present
// on both POSIX and Windows, same portable-fallback idea as bash's own
// `$(id -un)`/`$(hostname)`.
fn command_output(cmd: &str) -> String {
    Command::new(cmd)
        .output()
        .map(|o| String::from_utf8_lossy(&o.stdout).trim().to_string())
        .unwrap_or_default()
}

fn main() {
    let user = env::var("USER").unwrap_or_else(|_| command_output("whoami"));
    let tmpdir = env::var("TMPDIR").unwrap_or_else(|_| env::temp_dir().display().to_string());
    let hostname = env::var("HOSTNAME").unwrap_or_else(|_| command_output("hostname"));

    println!("USER={user}");
    println!("HOME={}", env::var("HOME").unwrap_or_default());
    println!("TMPDIR={tmpdir}");
    println!("HOSTNAME={hostname}");

    if let Ok(v) = env::var("USERNAME") {
        println!("USERNAME={v}");
    }
    if let Ok(v) = env::var("USERPROFILE") {
        println!("USERPROFILE={v}");
    }
    if let Ok(v) = env::var("TEMP") {
        println!("TEMP={v}");
    }
    if let Ok(v) = env::var("COMPUTERNAME") {
        println!("COMPUTERNAME={v}");
    }
}
