# Script Box 

This area has information about installation and useful scripts. 

## Requirements

* Ruby for any `.rb` scripts
* Powershell for any `.ps1` scripts

## RatatuiRuby Library

Some scripts will use the [RatatuiRuby](https://www.ratatui-ruby.dev/) TUI library.

### Installation 

You can install the library with the following:

```bash
gem update --system
gem install ratatui_ruby
```

## Cygwin

Cygwin will require some patches and build options to get this to work, changing the embedded Cargo.toml.

```bash
gem update --system
apt-cyg install ruby-devel
apt-cyg install libclang-devel
apt-cyg install clang

# clang.dll must match your installed clang version - derived dynamically
# rather than hardcoded, since it drifts with whatever clang apt-cyg installs
CLANG_VER=$(cygcheck -c clang | awk '/^clang / {print $2}' | cut -d. -f1,2)
ln -sf "/usr/bin/cygclang-${CLANG_VER}.dll" /usr/bin/clang.dll
export LIBCLANG_PATH=/usr/bin

# without this, bindgen's clang run fails with: error: 'short __wchar_t' is invalid
export BINDGEN_EXTRA_CLANG_ARGS="-D__wchar_t=__cygwin_wchar_t"

# without this, the final Rust link step fails with undefined references to
# rb_protect/rb_errinfo/rb_cBasicObject/etc (see patch file for why rb_sys doesn't
# add this itself on Cygwin)
export RUSTFLAGS="-C link-arg=-lruby400"

export RUBYOPT="-I$(pwd)/patches -rrb_sys_cygwin_patch" 
gem install ratatui_ruby

# fix interactive freezing
RATATUI_RUBY_GEM_PATH="$(ruby -e 'puts Gem::Specification.find_by_name("ratatui_ruby").gem_dir')"
cd "$RATATUI_RUBY_GEM_PATH/ext/ratatui_ruby"

# Must match whatever ratatui-crossterm actually pulled in on the install
# above (from Cargo.lock, not guessed) - otherwise Cargo resolves a second,
# separate crossterm instance instead of unifying features onto the one
# ratatui-crossterm actually uses, and use-dev-tty never takes effect.
CROSSTERM_VER=$(grep -A1 'name = "crossterm"' Cargo.lock \
  | grep version \
  | sed -E 's/.*"([0-9]+\.[0-9]+)\.[0-9]+"/\1/'
)

grep -q '\[dependencies.crossterm\]' Cargo.toml || cat >> Cargo.toml <<EOF

[dependencies.crossterm]
version = "$CROSSTERM_VER"
features = ["use-dev-tty"]
EOF

make
# `make` alone only rebuilds `ratatui_ruby.so` inside `ext/ratatui_ruby/` - that's not the
#  copy Ruby's `require` actually loads. Find the real one (the `/extensions/` path
#  segment is what distinguishes it from the just-built one sitting right here) and
#  overwrite it:
RATATUI_RUBY_SO_EXT_DEST=$(find ~/.local/share/gem /usr/share/gems \
  -path "*/extensions/*/ratatui_ruby.so" 2>/dev/null \
  | head -1
)
cp ratatui_ruby.so "$RATATUI_RUBY_SO_EXT_DEST"
```

**NOTES**:

* Patch (`patches/rb_sys_cygwin_patch.rb`) works around a Cygwin-specific bug in `rb_sys` 0.9.128:
   * `so_ext` mispredicts the filename Cargo's build produces (`ratatui_ruby.dll`, not
`libratatui_ruby.so`), causing `cp: cannot stat 'target/release/libratatui_ruby.so'`
if left unpatched. 
   * `platform_specific_rustc_args` override for the same missing,  `-lruby400` problem the `RUSTFLAGS` line above already covers, 
harmless belt-and-suspenders, `RUSTFLAGS` is what actually made the link succeed.
   * deliberately defensive about `require "rb_sys/cargo_builder"` failing:
     * `RUBYOPT` applies to *every* `ruby` subprocess for the life of the build, including a
narrow `ruby -e "..."` that `rb-sys-build`'s own Rust build script spawns just to dump
`RbConfig`,  a context with no RubyGems loaded at all. Without the rescue, that
unrelated subprocess crashes and takes the whole build down.
* **Fix** for *interactive* TUI mode (arrow-key navigation, `q`/Esc to quit) freezes:
  * **root cause**: ratatui_ruby's `crossterm` dependency defaults to reading input via `mio`'s `poll()`-based selector on Cygwin (grouped alongside far-less-tested targets like Solaris/QNX/Vita, not Linux's well-exercised epoll path), which doesn't reliably notice available input on a Cygwin tty.
  * **solution**: force crossterm's alternate `use-dev-tty` feature, a much simpler direct blocking read on `/dev/tty`, bypassing `mio` entirely, fixes it. This has to be added directly to the installed gem's own `Cargo.toml` (no way to pass it through `gem install`/`extconf.rb` cleanly)
* **Performance**: TUI is redrawn for every keypress.  As Cygwin's `fork()`/`CreateProcessW` emulation is dramatically slower than a real Linux fork, each redraw takes several seconds (confirmed iwth `strace`), sometimes stalling outright waiting on `subproc_ready`, compounding across every arrow-key press with no path back to responsiveness. 
  * **Solution**: The `cygwin_environment?` is now memoized.  Any similar interactive script against this gem should treat "no subprocess calls from redraw-path code, ever" as a hard rule on Cygwin specifically,
not just a nice-to-have.

#### Ubuntu 22.04

Ubuntu 22.04 uses a different GLIBC library than what the default package uses, so you'll need to compile your own version of the package.

```bash
gem update --system
sudo apt update && sudo apt install -y clang libclang-dev
gem install ratatui_ruby --platform ruby
```
