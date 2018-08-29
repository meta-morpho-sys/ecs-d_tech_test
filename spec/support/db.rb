# frozen_string_literal: true

require 'rspec'
require 'sequel'
require_relative '../../logs/logging'

LOGGER = my_logger

# -----------------------------------------------------------------------------
# Sets up the connection to the database.
# Takes a hash as argument as in the example.
# The keys should be the same as those stated in the Sequel gem docs
# https://sequel.jeremyevans.net/rdoc/files/doc/cheat_sheet_rdoc.html
# for each type of adapter.
# Example of connecting to MySQL database through *mysql2* adapter.
# get_db(host: 'localhost', database: 'test', user: 'root', password: 'yuliya')
# -----------------------------------------------------------------------------
def get_db(**db_conn_info)
  Sequel.mysql2(db_conn_info)
end

DB = get_db(host: 'localhost', database: 'test', user: 'root', password: 'yuliya')

unless DB.table_exists? 'versionTable'
  DB.create_table :versionTable do
    Integer :version
  end
  LOGGER.info '> Version table for <test> created'
end
DB[:versionTable].truncate
DB[:versionTable].insert(version: 0)

RSpec.configure do |c|
  # this *hook* will run once after the specs have been loaded but before the 1st
  # one actually runs
  c.before(:suite) do
    # puts '> Cleaning databases.'
  end

  # c.after(:suite) do
  #   puts '> Dropping table <test>'
  #   DB.drop_table :test
  # end

  # setup Database instance
  # The following will roll back the transactions
  # after each example has been run.
  c.around(:example, :db) do |example|
    puts '> Rolling back transaction'
    DB.transaction(rollback: :always) { example.run }
  end
end
