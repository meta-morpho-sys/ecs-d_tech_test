# frozen_string_literal: true

require 'rspec'
require 'sequel'
require_relative '../../lib/logging'

LOGGER = my_logger

DB = Sequel.mysql2(host: 'localhost', database: 'test', user: 'root', password: 'yuliya')


unless DB.table_exists? 'versionTable'
  DB.create_table :versionTable do
    Integer :version
    LOGGER.info '> Version table for test created'
  end
end
versions = DB[:versionTable]
versions.insert(version: 0)

RSpec.configure do |c|
  c.before(:suite) do
    puts '> Cleaning databases.'
    versions.truncate
  end

  # setup DatabaseY instance
  # The following will roll back the transactions
  # after each example has been run.
  c.around(:example, :db) do |example|
    puts '> Rolling back transaction'
    DB.transaction(rollback: :always) { example.run }
  end
end
