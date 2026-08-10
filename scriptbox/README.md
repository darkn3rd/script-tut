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

#### Ubuntu 22.04

Ubuntu 22.04 uses a different GLIBC library than what the default package uses, so you'll need to compile your own version of the package.

```bash
gem update --system
sudo apt update && sudo apt install -y clang libclang-dev
gem install ratatui_ruby --platform ruby
```




pacman -S --needed mingw-w64-ucrt-x86_64-clang
MAKEFLAGS="-j1" gem install ratatui_ruby --platform ruby
BINDGEN_EXTRA_CLANG_ARGS="-msse -mavx" gem install ratatui_ruby --platform ruby

