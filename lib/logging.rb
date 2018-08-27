# frozen_string_literal: true

require 'ansi/logger'

def my_logger
  ANSI::Logger.new(STDOUT)
end
