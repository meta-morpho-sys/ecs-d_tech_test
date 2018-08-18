#!/usr/bin/env ruby
# frozen_string_literal: true

DB = Sequel.mysql2(host: ENV['host'], database: ENV['db'], user: ENV['user'], password: ENV['pwd'])

unless DB.table_exists? 'versionTable'
  DB.create_table :versionTable do
    Integer :version
    print 'Table created'
  end
end

class DatabaseYuliya
  def initialize(dir)
    @dir = dir
  end

  def db_version
    DB[:versionTable].map(:version).first
    p 'got here'
  end

  def db_version=(version)
    DB[:versionTable].update(version: version)
  end

  def upgrade_db
    scripts = Scrypts.look_up(@dir)
    if get_highest_script(dir) > db_version
      files_to_run = select_higher_versions(dir)
      files_to_run.each { |file| db.run File.read dir + '/' + file }
      db_version = 49
    else
      puts 'DB up to date!'
    end
  end

  def select_higher_versions(dir)
    scan_scripts_names(dir).select do |name|
      version(name) > db_version
    end
  end

  def get_highest_script(dir)
    get_versions(Scrypts.look_up(dir)).max
  end


# Returns a collection of script versions
  def get_versions(strings)
    strings.map { |s| version(s) }
  end
end
