# frozen_string_literal: true

require 'rspec'
require 'sequel'
require_relative '../../lib/logging'

LOGGER = my_logger

def db
  Sequel.mysql2(host: 'localhost', database: 'test', user: 'root', password: 'yuliya')
end

DB = db

unless DB.table_exists? 'versionTable'
  DB.create_table :versionTable do
    Integer :version
  end
  LOGGER.info '> Version table for <test> created'
end
DB[:versionTable].truncate
DB[:versionTable].insert(version: 0)

RSpec.configure do |c|
  c.before(:suite) do
    # TODO: clarify how the before :suite hook works. Maybe better :each?
    # puts '> Cleaning databases.'
  end

  c.after(:suite) do
    puts '> Dropping table <test>'
    DB.drop_table :test
  end

  # setup DatabaseY instance
  # The following will roll back the transactions
  # after each example has been run.
  c.around(:example, :db) do |example|
    puts '> Rolling back transaction'
    DB.transaction(rollback: :always) { example.run }
  end
end
