require 'yaml'

PACKAGE_TYPES = %w[brew cask tap cpan cpanm system].freeze

# flatten - walks the macos.yml tree in document order and produces one
#  array of "steps". A step is either a package (brew/cask/tap/cpan/cpanm/
#  system) or a script - including scripts attached to a package via a
#  sibling `script:` key, which become their own step (tagged with
#  attached_to) immediately following the package they belong to, so a
#  package and its post-install script can be moved together as a unit.
def flatten(node, path = [])
  steps = []
  return steps unless node.is_a?(Hash)

  if node['packages'].is_a?(Array)
    node['packages'].each do |entry|
      type = PACKAGE_TYPES.find { |t| entry.key?(t) } || (entry.key?('script') ? 'script' : nil)
      next unless type

      steps << {
        type: type,
        name: entry[type],
        meets: entry['meets'],
        needs: entry['needs'],
        path: path.join('.')
      }
      if type != 'script' && entry['script']
        steps << { type: 'script', name: entry['script'], attached_to: entry[type], path: path.join('.') }
      end
    end
  end

  node.each do |key, value|
    next if key == 'packages'
    steps.concat(flatten(value, path + [key])) if value.is_a?(Hash)
  end

  steps
end

# unit_span - the contiguous [start, end] index range that must move
#  together with the provider at `index`: any directly-preceding `tap`
#  steps in the *same* package list (a cask's tap must stay right before
#  it), plus a directly-following script step attached to this provider.
def unit_span(steps, index)
  start = index
  while start > 0 &&
        steps[start - 1][:type] == 'tap' &&
        steps[start - 1][:path] == steps[index][:path]
    start -= 1
  end

  finish = index
  nxt = steps[index + 1]
  finish += 1 if nxt && nxt[:type] == 'script' && nxt[:attached_to] == steps[index][:name]

  [start, finish]
end

# resolve! - for every step with `needs: X`, finds the first step with
#  `meets: X` (first listed provider wins) and, if that provider currently
#  sits after the consumer, moves its whole unit to just before it.
#  Leaves order untouched when the provider already comes first.
def resolve!(steps)
  loop do
    moved = false

    steps.each_with_index do |consumer, c_index|
      next unless consumer[:needs]

      p_index = steps.index { |s| s[:meets] == consumer[:needs] }
      next unless p_index
      next if p_index < c_index

      start, finish = unit_span(steps, p_index)
      unit = steps.slice!(start, finish - start + 1)
      insert_at = steps.index(consumer)
      steps.insert(insert_at, *unit)
      moved = true
      break
    end

    break unless moved
  end
  steps
end

if __FILE__ == $PROGRAM_NAME
  tree = YAML.load_file(File.join(__dir__, '..', 'config', 'macos.yml'))
  steps = flatten(tree['macos'])
  resolve!(steps)
  steps.each do |s|
    extra = []
    extra << "meets:#{s[:meets]}" if s[:meets]
    extra << "needs:#{s[:needs]}" if s[:needs]
    extra << "attached_to:#{s[:attached_to]}" if s[:attached_to]
    puts "[#{s[:path]}] #{s[:type]}: #{s[:name]}" + (extra.empty? ? '' : "  (#{extra.join(', ')})")
  end
end
