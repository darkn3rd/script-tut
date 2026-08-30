#!/usr/bin/env ruby
require 'json'
require 'net/http'
require 'optparse'
require 'uri'
require 'yaml'

VERSIONS_PATH = File.expand_path('desired_versions.yml', __dir__)

def get_text(url, headers = {})
  uri = URI(url)
  request = Net::HTTP::Get.new(uri)
  headers.each { |key, value| request[key] = value }
  response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
    http.request(request)
  end
  raise "GET #{url}: HTTP #{response.code}" unless response.is_a?(Net::HTTPSuccess)

  response.body
end

def latest_rust(entry)
  manifest = get_text(entry.fetch('source'))
  match = manifest.match(/^version\s*=\s*"(\d+\.\d+\.\d+)(?:\s|\")/)
  raise 'Rust stable manifest did not contain pkg.rust.version' unless match

  match[1]
end

def latest_github(entry)
  repository = entry.fetch('repository')
  body = get_text(
    "https://api.github.com/repos/#{repository}/releases/latest",
    'Accept' => 'application/vnd.github+json',
    'User-Agent' => 'script-tut-buildbox-version-checker'
  )
  JSON.parse(body).fetch('tag_name').sub(/^v/, '')
end

def latest_for(entry)
  case entry.fetch('track')
  when 'rust_stable' then latest_rust(entry)
  when 'github_latest' then latest_github(entry)
  when 'ubuntu_noble' then :distribution
  when 'manual' then :manual
  else raise "unsupported update track: #{entry['track']}"
  end
end

def write_versions(path, document)
  File.write(path, document.to_yaml, mode: 'wb')
end

if __FILE__ == $PROGRAM_NAME
  options = { write: false }
  OptionParser.new do |parser|
    parser.banner = 'usage: check_versions.rb [--write]'
    parser.on('--write', 'update desired values when an upstream version is newer') do
      options[:write] = true
    end
  end.parse!

  document = YAML.load_file(VERSIONS_PATH)
  changed = false
  stale = false

  document.fetch('versions').each do |name, entry|
    latest = latest_for(entry)
    case latest
    when :distribution
      puts format('%-12s %-12s tracked by Ubuntu Noble apt', name, entry['desired'])
    when :manual
      puts format('%-12s %-12s manual (%s planned)', name, entry['desired'], Array(entry['planned']).join(', '))
    else
      current = entry.fetch('desired').to_s
      if Gem::Version.new(current) < Gem::Version.new(latest)
        stale = true
        puts format('%-12s %-12s -> %s', name, current, latest)
        if options[:write]
          entry['desired'] = latest
          # A version-specific artifact checksum must be refreshed from the
          # upstream release before a component may build with the new value.
          entry['sha256'] = nil if entry.key?('sha256')
          changed = true
        end
      else
        puts format('%-12s %-12s current', name, current)
      end
    end
  end

  write_versions(VERSIONS_PATH, document) if changed
  warn 'desired versions updated; refresh provenance/checksums and rebuild components' if changed
  exit 2 if stale && !options[:write]
end
