# frozen_string_literal: true

require 'sequel'

DB = Sequel.mysql2(host: 'localhost', database: 'tech_test', user: 'root', password: 'yuliya')

unless DB.table_exists? 'versionTable'
  DB.create_table :versionTable do
    Integer :version
    print 'Table created'
  end
end
