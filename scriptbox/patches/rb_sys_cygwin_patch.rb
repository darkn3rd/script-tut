# frozen_string_literal: true

# Works around two Cygwin-specific bugs in rb_sys (lib/rb_sys/cargo_builder.rb),
# reproduced against rb_sys 0.9.128 building the ratatui_ruby-1.5.0 native extension.
#
# Both bugs share the same root cause: rb_sys detects "is this a Windows-like
# target needing special handling?" via either RbConfig::CONFIG["SOEXT"] (which is
# "so" on Cygwin - Ruby's own require-facing convention, true on every platform,
# not evidence of ELF format) or Gem::WIN_PATTERNS / makefile_config("target_os")
# matching "mingw" (Cygwin matches neither, since RubyGems treats "cygwin" as its
# own platform, distinct from "mingw"/"mswin"). So Cygwin falls through every
# Windows-specific branch even though its real binary format is a genuine Windows
# PE DLL, same as a native Windows target.
#
# 1) so_ext - used to predict the filename Cargo's `cdylib` build produces.
#    Verified empirically (throwaway `cargo build --release` on this machine):
#    Cargo names it `<crate>.dll`, no "lib" prefix - not `lib<crate>.so`. Without
#    this fix, rb_sys looks for the wrong path and fails with e.g.:
#      cp: cannot stat 'target/release/libratatui_ruby.so'
#    This only changes where rb_sys looks for Cargo's raw output. The final
#    installed filename Ruby's `require` loads is computed separately from the
#    real RbConfig::CONFIG["DLEXT"] (rb_sys/mkmf.rb's DLLIB) and is unaffected -
#    it's still correctly named `<crate>.so`.
#
# 2) platform_specific_rustc_args - only adds `-lruby400` (RbConfig's
#    LIBRUBYARG_SHARED) to the Rust linker flags when `mingw_target?` is true.
#    Without it, the final link step fails with undefined references to Ruby C
#    API symbols pulled in by `magnus`/`rb-sys`, e.g.:
#      undefined reference to `rb_protect'
#      undefined reference to `rb_errinfo'
#      undefined reference to `rb_cBasicObject'
#
# Usage:
#   RUBYOPT="-I$(pwd)/patches -rrb_sys_cygwin_patch" gem install ratatui_ruby
#
# Note: this alone does not fix clang rejecting Cygwin's `__wchar_t` typedef
# during bindgen ("error: 'short __wchar_t' is invalid") - that needs
# BINDGEN_EXTRA_CLANG_ARGS set separately (see README.md).
#
# RUBYOPT applies to EVERY `ruby` subprocess for the life of the build - including
# a narrow `ruby -e "..."` that rb-sys-build's own Rust build script spawns just to
# dump RbConfig. In that context, plain `require "rb_sys/cargo_builder"` can raise
# LoadError (RubyGems doesn't resolve the gem there), which would otherwise crash
# an unrelated subprocess and take the whole build down. So this explicitly finds
# rb_sys's lib dir via glob instead of relying on gem auto-activation, and no-ops
# instead of raising if it still can't be found.

if RbConfig::CONFIG["host_os"].to_s.include?("cygwin")
  rb_sys_lib = Dir[File.expand_path("~/.local/share/gem/ruby/*/gems/rb_sys-*/lib")].max_by { |p| p[/rb_sys-([\d.]+)/, 1].to_s }
  $LOAD_PATH.unshift(rb_sys_lib) if rb_sys_lib && !$LOAD_PATH.include?(rb_sys_lib)

  begin
    require "rb_sys/cargo_builder"
  rescue LoadError, StandardError
    # Not usable in this subprocess (e.g. rb-sys-build's RbConfig dump runs
    # `ruby -e` without RubyGems loaded at all, so cargo_builder.rb's own
    # `require "rubygems/ext"` raises NameError: uninitialized constant Gem) -
    # nothing to patch here, and nothing downstream needs it in that context.
  else
    module RbSysCygwinPatch
      def so_ext
        "dll"
      end

      def platform_specific_rustc_args(dest_dir, flags = [])
        flags = super
        flags += libruby_args(dest_dir)
        flags
      end
    end

    RbSys::CargoBuilder.prepend(RbSysCygwinPatch)
  end
end
