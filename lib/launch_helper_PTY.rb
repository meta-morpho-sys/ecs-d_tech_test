# frozen_string_literal: true

require 'pty'

def launch(dir)
  bin = File.expand_path('../../bin/db_upgrade_ecs', __FILE__)
  args = " -d #{dir} -u root -h localhost -n test -p"
  command_line = bin + args

  PTY.spawn(command_line) { |r, w, pid|
    buffer = r.gets # Password:
    puts buffer

    w.puts 'yuliya' # Inputs the password in the prompt
    return r.gets
  }
end
