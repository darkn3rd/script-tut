# Script Box 

This area has information about installation and useful scripts. 


## RatatuiRuby Library

Some scripts will use the [RatatuiRuby](https://www.ratatui-ruby.dev/) TUI library.

### Installation 

You can install the library with the following:

```bash
gem update --system
gem install ratatui_ruby
```

## Cygwin

Confirmed working end-to-end: `gem install ratatui_ruby` succeeds and
`require 'ratatui_ruby'` loads, against a real build on this machine
(Ruby 4.0.6, rb_sys 0.9.128, rb-sys 0.9.123, magnus 0.8.2).

```bash
gem update --system
apt-cyg install ruby-devel
apt-cyg install libclang-devel
apt-cyg install clang

# clang.dll must match your installed clang version - check with: cygcheck -c clang
ln -sf /usr/bin/cygclang-20.1.dll /usr/bin/clang.dll
export LIBCLANG_PATH=/usr/bin

# without this, bindgen's clang run fails with: error: 'short __wchar_t' is invalid
export BINDGEN_EXTRA_CLANG_ARGS="-D__wchar_t=__cygwin_wchar_t"

# without this, the final Rust link step fails with undefined references to
# rb_protect/rb_errinfo/rb_cBasicObject/etc (see patch file for why rb_sys doesn't
# add this itself on Cygwin)
export RUSTFLAGS="-C link-arg=-lruby400"

RUBYOPT="-I$(pwd)/patches -rrb_sys_cygwin_patch" gem install ratatui_ruby
```

`patches/rb_sys_cygwin_patch.rb` works around a Cygwin-specific bug in `rb_sys`
(reproduced on 0.9.128 - see the file's header comment for the full explanation):
`so_ext` mispredicts the filename Cargo's build produces (`ratatui_ruby.dll`, not
`libratatui_ruby.so`), causing `cp: cannot stat 'target/release/libratatui_ruby.so'`
if left unpatched. The patch also carries a `platform_specific_rustc_args` override
for the same missing-`-lruby400` problem the `RUSTFLAGS` line above already covers -
harmless belt-and-suspenders, `RUSTFLAGS` is what actually made the link succeed.

The patch is deliberately defensive about `require "rb_sys/cargo_builder"` failing:
`RUBYOPT` applies to *every* `ruby` subprocess for the life of the build, including a
narrow `ruby -e "..."` that `rb-sys-build`'s own Rust build script spawns just to dump
`RbConfig` - a context with no RubyGems loaded at all. Without the rescue, that
unrelated subprocess crashes and takes the whole build down.

#### Interactive TUI (`--format tui`) on Cygwin

The steps above get `gem install ratatui_ruby` and `require 'ratatui_ruby'` working,
but the *interactive* TUI mode (arrow-key navigation, `q`/Esc to quit) needs one more
fix, confirmed working end-to-end against a real `ruby verify_commands.rb --format tui`
session: without it, the TUI draws its first frame fine but then completely freezes -
no response to arrows, `q`, Esc, or even Ctrl-C (raw mode disables Ctrl-C's signal
delivery by design; the freeze itself is the real symptom) - and has to be killed from
another terminal. Confirmed this reproduces identically in both mintty and Windows
Terminal, and is specific to the Cygwin build - the same script works fine via MSYS2,
WSL2, and native Windows/PowerShell.

Root cause: `ratatui_ruby`'s `crossterm` dependency defaults to reading input via
`mio`'s `poll()`-based selector on Cygwin (grouped alongside far-less-tested targets
like Solaris/QNX/Vita, not Linux's well-exercised epoll path), and that path doesn't
reliably notice available input on a Cygwin tty. Forcing crossterm's alternate
`use-dev-tty` feature - a much simpler direct blocking read on `/dev/tty`, bypassing
`mio` entirely - fixes it. This has to be added directly to the installed gem's own
`Cargo.toml` (no way to pass it through `gem install`/`extconf.rb` cleanly) and rebuilt:

```bash
cd "$(ruby -e 'puts Gem::Specification.find_by_name("ratatui_ruby").gem_dir')/ext/ratatui_ruby"

cat >> Cargo.toml <<'EOF'

[dependencies.crossterm]
version = "0.29"
features = ["use-dev-tty"]
EOF

export LIBCLANG_PATH=/usr/bin
export BINDGEN_EXTRA_CLANG_ARGS="-D__wchar_t=__cygwin_wchar_t"
export RUSTFLAGS="-C link-arg=-lruby400"
export RUBYOPT="-I/path/to/scriptbox/patches -rrb_sys_cygwin_patch"
make
```

`make` alone only rebuilds `ratatui_ruby.so` inside `ext/ratatui_ruby/` - that's not the
copy Ruby's `require` actually loads. Find the real one and overwrite it:

```bash
find ~/.local/share/gem /usr/share/gems -name ratatui_ruby.so 2>/dev/null
# copy ext/ratatui_ruby/ratatui_ruby.so over the one under
# .../extensions/x86_64-cygwin/<version>/ratatui_ruby-1.5.0/ratatui_ruby/ratatui_ruby.so
```

This alone is *not* sufficient by itself, though - confirmed directly reverting just this
change (keeping everything else) reproduced the freeze again. The other half of the fix
already lives in `verify_commands.rb` itself: `cygwin_environment?` shells out to
`uname` to detect a real Cygwin session, and was originally uncached - harmless
normally, but `format_tui`'s `draw_tui_frame` calls it (via `status_text`/
`platform_inapplicable?`) fresh for *every row on every redraw*, and the TUI redraws on
every keypress. Cygwin's `fork()`/`CreateProcessW` emulation is dramatically slower
than a real Linux fork, and `strace` against a live hang confirmed multiple seconds
spent per redraw, sometimes stalling outright waiting on `subproc_ready` - compounding
across every arrow-key press with no path back to responsiveness. `cygwin_environment?`
is now memoized (the answer can't change during one run, so this is a pure win, not a
tradeoff) - anyone writing a similar interactive script against this gem should treat
"no subprocess calls from redraw-path code, ever" as a hard rule on Cygwin specifically,
not just a nice-to-have.

#### Ubuntu 22.04

Ubuntu 22.04 uses a different GLIBC library than what the default package uses, so you'll need to compile your own version of the package.

```bash
gem update --system
sudo apt update && sudo apt install -y clang libclang-dev
gem install ratatui_ruby --platform ruby
```
