require 'json'

# Queries Name/CommandLine/ParentProcessId for a PID via WMI/CIM. Returns
# nil if the process can't be found (e.g. it already exited).
def win_process_info(pid)
  out = IO.popen(['powershell.exe', '-NoProfile', '-Command',
    "Get-CimInstance Win32_Process -Filter \"ProcessId=#{pid}\" | " \
    "Select-Object Name,CommandLine,ParentProcessId | ConvertTo-Json -Compress"
  ]) { |io| io.read }.strip
  return nil if out.empty?
  JSON.parse(out)
rescue StandardError
  nil
end

# detect_shell - walks up the process tree from our parent, skipping past
# any cmd.exe that was started as a "/c <command>" wrapper (that's what
# Windows always interposes to run a .bat file, e.g. rake.bat, from a
# non-cmd shell like PowerShell) rather than trusting cmd.exe's mere
# *presence* as a parent. A cmd.exe NOT started with /c is a genuine
# interactive session, not a wrapper, so that's where we stop.
def detect_shell
  return 'Unix Shell' unless Gem.win_platform?

  pid = Process.ppid
  loop do
    info = win_process_info(pid)
    break 'Unknown Windows Shell' unless info

    name = info['Name'].to_s.downcase
    if name.include?('powershell') || name == 'pwsh.exe'
      break 'PowerShell'
    elsif name == 'cmd.exe'
      if info['CommandLine'].to_s =~ %r{/c\b}i
        pid = info['ParentProcessId']
        next
      else
        break 'Command Prompt (CMD)'
      end
    else
      break "Other Windows Shell/Host (#{info['Name']})"
    end
  end
end

puts "Your Ruby script is executing inside: #{detect_shell}"
