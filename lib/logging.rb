# frozen_string_literal: true

require 'ansi/logger'

# Logger Wrapper that gives global access to Logger.
class MyLogger
  def self.log
    @logger = ANSI::Logger.new($stdout) if @logger.nil?
    @logger.formatter = proc do |severity, datetime, _progname, msg|
      date_format = datetime.strftime('%Y/%m/%d %H:%M:%S')
      "#{date_format} -- #{severity}: #{msg}\n"
    end
    @logger
  end
end
