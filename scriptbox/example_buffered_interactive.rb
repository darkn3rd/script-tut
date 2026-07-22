require 'open3'

# Array of names to inject one by one
names_to_send = ["joaquin", "justin", "sally", "quit"]

Open3.popen3("f21.loop.cmd") do |stdin, stdout, stderr, wait_thr|
  begin
    while wait_thr.alive?
      # Read small chunks up to the question prompt
      prompt = stdout.readpartial(1024)
      print prompt

      if prompt.include?("Enter your name")
        # Grab the next name from our array
        next_name = names_to_send.shift
        
        if next_name
          stdin.puts next_name
          # Flush instantly so Windows receives the keystrokes
          stdin.flush 
        end
      end
    end
  rescue EOFError
    # This catches the EOFError cleanly when the batch file exits
    puts "\n[Ruby: Batch script stream closed cleanly]"
  end
end
