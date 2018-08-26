# frozen_string_literal: true

# This is INTEGRATION testing of the entire utility.

require 'tmpdir'
require 'pty'
require_relative '../support/db'
require_relative '../../lib/database'
require_relative '../../lib/script'
require_relative '../../lib/logging'

describe 'overcomes the STDIN.noecho error problem' do
  example 'it works once stdio buffering is taken into account' do
    # Launch the utility, give it input(password)
    # and check that no ENOTTY error is thrown.
    # This launches a process and gives us control over input and output strings

    # See https://ruby-doc.org/stdlib-2.4.1/libdoc/pty/rdoc/PTY.html
    # for how this uses pty.
    # IMPORTANT! The example given in the docs above only illustrates BAD CODE
    # case, when IO.pipe is used.

    # The example below is how the PTY should be used. It's based on the research
    # in the Ruby PTY source code and its tests that show some simple use cases.
    bin = File.expand_path('../../../lib/upgrade_launch.rb', __FILE__)
    args = ' -d .. -u root -h localhost -n ecs_d -p'
    command_line = bin + args

    PTY.spawn(command_line) { |r, w, pid|
      buffer = r.gets # Password:
      puts buffer

      w.puts 'yuliya' # Inputs the password in the prompt
      buffer = r.gets
      puts buffer

      expect(buffer).to include('Current DB version is 49')
    }
  end
end

def launch(dir)
  bin = File.expand_path('../../../lib/upgrade_launch.rb', __FILE__)
  args = ' -d .. -u root -h localhost -n ecs_d -p'
  command_line = bin + args

  PTY.spawn(command_line) { |r, w, pid|
    buffer = r.gets # Password:
    puts buffer

    w.puts 'yuliya' # Inputs the password in the prompt
    buffer = r.gets
    puts buffer
  }
end


# run against dir test1
#
# run against dir test2
#
# run against dir test3

describe 'Run from CL' do
  it 'runs the script'
end

