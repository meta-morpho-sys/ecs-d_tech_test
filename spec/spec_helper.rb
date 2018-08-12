# frozen_string_literal: true

require 'rspec'
require 'simplecov'
require 'simplecov-console'


RSpec.configure do |config|
  config.order = :random
end

RSpec.configure do |rspec|
  rspec.alias_example_group_to :pdescribe, ​pry: true
  rspec.alias_example_to :pit, ​pry: true

  rspec.after(:example, ​pry: true) do |ex|
    require 'pry'
    # binding.pry
  end
end

SCF = SimpleCov::Formatter
formatters = [SCF::Console, SCF::HTMLFormatter]
SimpleCov.formatter = SCF::MultiFormatter.new(formatters)

SimpleCov.start
