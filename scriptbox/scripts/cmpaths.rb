require 'tomlrb'

# cmpaths.rb - ../../cmpaths.toml, read once and cached, giving every
#  generate_*.rb script its own default out_path so it isn't hand-typed
#  (and kept in sync by hand) on every invocation. See cmpaths.toml's
#  own header comment for the file's own shape.
REPO_ROOT = File.expand_path('../..', __dir__)
CMPATHS_FILE = File.join(REPO_ROOT, 'cmpaths.toml')

def cmpaths
  @cmpaths ||= Tomlrb.load_file(CMPATHS_FILE)
end

# cmpath(tool, key, platform) - cmpaths.toml's own [tool] key value,
#  {platform} substituted for the real platform name, resolved to an
#  absolute path rooted at the repo root - confirmed directly this
#  matters: cmpaths.toml's own paths are written repo-root-relative,
#  and a generate_*.rb script gets run from all kinds of different
#  working directories (repo root by hand, scriptbox/scripts/ via
#  `rake generate:*`, ...) - returning the bare relative string let it
#  silently write into a stray scriptbox/scripts/configbox/ tree
#  instead of the real one, once from inside that directory. Raises
#  loudly, not nil, on an unknown tool/key - a typo here should never
#  silently fall through to writing wherever Dir.pwd happens to be.
def cmpath(tool, key, platform)
  section = cmpaths[tool.to_s] or raise "cmpaths.toml: no [#{tool}] section"
  template = section[key.to_s] or raise "cmpaths.toml: no [#{tool}] key '#{key}'"
  File.join(REPO_ROOT, template.gsub('{platform}', platform))
end
