#!/usr/bin/env ruby
require 'fileutils'
require 'optparse'
require 'yaml'

ROOT = File.expand_path(__dir__)

def load_yaml(path)
  YAML.load_file(path) || {}
end

def component_order(requested, registry)
  selected = []
  visiting = {}
  visit = lambda do |name|
    raise "unknown component '#{name}'" unless registry.key?(name)
    raise "component dependency cycle at '#{name}'" if visiting[name]
    return if selected.include?(name)

    visiting[name] = true
    Array(registry[name]['needs']).each do |capability|
      provider = requested.find { |candidate| Array(registry[candidate]['provides']).include?(capability) }
      raise "component '#{name}' needs '#{capability}', but the profile selects no provider" unless provider
      visit.call(provider)
    end
    visiting.delete(name)
    selected << name
  end
  requested.each { |name| visit.call(name) }
  selected
end

def read_fragment(relative)
  File.binread(File.join(ROOT, relative)).rstrip
end

def generate_dockerfile(profile_path, output_path)
  profile = load_yaml(profile_path)
  registry = load_yaml(File.join(ROOT, 'components.yml')).fetch('components')
  versions = load_yaml(File.join(ROOT, 'desired_versions.yml')).fetch('versions')
  base_name = profile.fetch('base')
  base_path = File.join(ROOT, 'bases', base_name, 'provenance.yml')
  base = load_yaml(base_path)
  raise "base '#{base_name}' is still planned" if base['status'] == 'planned'

  requested = profile.fetch('components')
  order = component_order(requested, registry)
  order.each do |name|
    status = registry.fetch(name).fetch('status')
    raise "component '#{name}' is still planned" if status == 'planned'
  end

  image = base.dig('upstream', 'image')
  digest = base.dig('upstream', 'digest')
  raise "base '#{base_name}' has no image or digest" if image.nil? || digest.nil?

  lines = ['# syntax=docker/dockerfile:1', '']
  lines << '# Donor stages: only explicit language payloads are copied into the final Noble image.'
  order.each do |name|
    stage = registry[name]['stage']
    next unless stage
    lines << "# --- donor: #{name} ---"
    lines << read_fragment(stage)
    lines << ''
  end

  lines << "FROM #{image}@#{digest} AS final"
  lines << ''
  lines << 'ARG DEBIAN_FRONTEND=noninteractive'
  lines << "ARG POWERSHELL_VERSION=#{versions.dig('powershell', 'desired')}"
  lines << "ARG POWERSHELL_SHA256=#{versions.dig('powershell', 'sha256')}"
  lines << ''

  order.each do |name|
    fragment = registry[name]['fragment']
    next unless fragment
    lines << "# --- component: #{name} ---"
    lines << read_fragment(fragment)
    lines << ''
  end

  workdir = profile.dig('final', 'workdir') || '/workspace'
  command = profile.dig('final', 'command') || ['/bin/bash']
  lines << "RUN mkdir -p #{workdir}"
  lines << "WORKDIR #{workdir}"
  if profile.dig('final', 'verify_all')
    checks = [
      'dotnet --version',
      'python3 --version',
      'ruby --version',
      'perl --version',
      'go version',
      'rustc --version',
      'cargo --version',
      'java --version',
      'javac --version',
      'groovy --version',
      'php --version',
      %q{pwsh -NoLogo -NoProfile -Command '$PSVersionTable.PSVersion'},
      %q{printf 'puts [info patchlevel]\n' | tclsh},
      'zsh --version',
      'tcsh --version'
    ]
    lines << "RUN #{checks.join(" \\\n    && ")}"
  end
  lines << "CMD #{command.to_s}"
  lines << ''

  FileUtils.mkdir_p(File.dirname(File.expand_path(output_path)))
  File.write(output_path, lines.join("\n"), mode: 'wb')
  output_path
end

if __FILE__ == $PROGRAM_NAME
  output = nil
  parser = OptionParser.new do |opts|
    opts.banner = 'usage: generate_dockerfile.rb PROFILE --output PATH'
    opts.on('--output PATH') { |value| output = value }
  end
  parser.parse!
  profile = ARGV.shift
  if profile.nil? || output.nil?
    warn parser
    exit 1
  end
  puts "wrote #{generate_dockerfile(profile, output)}"
end
