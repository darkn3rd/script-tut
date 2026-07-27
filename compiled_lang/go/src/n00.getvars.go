package main

import (
	"fmt"
	"os"
	"os/user"
)

// Enumerate a fixed set of well-known environment variables, printing
// "NAME=value" for each. USER, TMPDIR, and HOSTNAME aren't reliably set
// as actual environment entries on every POSIX host (confirmed
// directly: missing on GitHub Actions' ubuntu-latest runners) - fall
// back to Go's own portable equivalent for each so this stays reliable
// anywhere, matching shell_scripts/bash/scripts/n00.getvars.bash's own
// fallback approach. USERNAME/USERPROFILE/TEMP/COMPUTERNAME are
// Windows-only concepts with no POSIX equivalent - printed only when
// actually present.
func main() {
	userName := os.Getenv("USER")
	if userName == "" {
		if u, err := user.Current(); err == nil {
			userName = u.Username
		}
	}

	tmpdir := os.Getenv("TMPDIR")
	if tmpdir == "" {
		tmpdir = os.TempDir()
	}

	hostname := os.Getenv("HOSTNAME")
	if hostname == "" {
		hostname, _ = os.Hostname()
	}

	fmt.Println("USER=" + userName)
	fmt.Println("HOME=" + os.Getenv("HOME"))
	fmt.Println("TMPDIR=" + tmpdir)
	fmt.Println("HOSTNAME=" + hostname)

	if v := os.Getenv("USERNAME"); v != "" {
		fmt.Println("USERNAME=" + v)
	}
	if v := os.Getenv("USERPROFILE"); v != "" {
		fmt.Println("USERPROFILE=" + v)
	}
	if v := os.Getenv("TEMP"); v != "" {
		fmt.Println("TEMP=" + v)
	}
	if v := os.Getenv("COMPUTERNAME"); v != "" {
		fmt.Println("COMPUTERNAME=" + v)
	}
}
