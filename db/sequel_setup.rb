# frozen_string_literal: true

require 'sequel'

# ENV['DATABASE_URL'] ||= "./app/db/#{ENV.fetch('RACK_ENV', 'development')}.db"
ENV['DATABASE_URL'] = './app/db/tech_test.db'

DB = Sequel.mysql2(:host => 'localhost', :database => 'tech_test', :user => "root", :password => "yuliya")

# DB = Sequel.mysql2(ENV['DATABASE_URL'])

unless DB.table_exists? 'versionTable'
  DB.create_table :versionTable do
    Integer :version
    print 'Table created'
  end
end
