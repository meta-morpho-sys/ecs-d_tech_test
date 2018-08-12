# frozen_string_literal: true

require 'rspec'
require 'rspec_sequel_matchers'
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

RSpec.configure do |config|
  config.profile_examples = 5
  config.order = :random
  config.include RspecSequel::Matchers
  # Global require of 'support/db' when tests touch our DB.
  config.when_first_matching_example_defined(:db) do
    require_relative 'support/db'
  end
end


SCF = SimpleCov::Formatter
formatters = [SCF::Console, SCF::HTMLFormatter]
SimpleCov.formatter = SCF::MultiFormatter.new(formatters)

SimpleCov.start
