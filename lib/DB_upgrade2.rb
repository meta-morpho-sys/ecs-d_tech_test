#!/usr/bin/env ruby
# frozen_string_literal: true

require 'sequel'

class DatabaseYuliya
  def initialize(dir, user, host, database, pwd)
    @dir = dir
    @db = Sequel.mysql2(host: host, database: database, user: user, password: pwd)
    unless @db.table_exists? 'versionTable'
      @db.create_table :versionTable do
        Integer :version
        puts 'Table created'
      end
    end
    @version_table = @db[:versionTable]
  end

  def get_db_version
    @version_table.map(:version).first
  end

  def set_db_version=(version)
    if db_version.nil?
      @version_table.insert(version: version)
    else
      @version_table.update(version: version)
    end
  end


  def upgrade_db
    current_db_version = get_db_version

    p scripts = Scrypts.look_up(@dir)

    # if get_highest_script(@dir) > db_version
    #   files_to_run = select_higher_versions(@dir)
    #   files_to_run.each { |file| db.run File.read @dir + '/' + file }
    # TODO: When updating the db version check for nil. In nil? then INSERT if not, then UPDATE
    # else
    #   puts 'DB up to date!'
    # end
  end

#   def select_higher_versions(dir)
#     scan_scripts_names(dir).select do |name|
#       version(name) > db_version
#     end
#   end
#
#   def get_highest_script(dir)
#     get_versions(Scrypts.look_up(dir)).max
#   end
#
#
# # Returns a collection of script versions
#   def get_versions(strings)
#     strings.map { |s| version(s) }
#   end
end
