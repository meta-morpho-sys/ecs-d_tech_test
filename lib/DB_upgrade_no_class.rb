#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../db/sequel_setup'


VERSION_TABLE = DB[:versionTable]

def current_db_version
  VERSION_TABLE.map(:version).first
end

def upgrade_db(sql_scripts_dir, db_username, db_host, db_name, db_password)
  if get_highest_script_num > current_db_version
    # Updates DB
    # Run those files that are higher version than Current DB version
    files_to_run = select_higher_versions
    files_to_run.each { |file| DB.run File.read sql_scripts_dir + '/' + file }
    VERSION_TABLE.update(version: get_highest_script_num)
  else
    'DB up to date!'
  end
end

def select_higher_versions
  scan_scripts_names.select do |name|
    get_num(name) > current_db_version
  end
end

def get_highest_script_num
  get_numbers(scan_scripts_names).max
end

# Returns a collection of filenames as strings
def scan_scripts_names(sql_scripts_dir)
  Dir.entries(sql_scripts_dir)
    .select { |f| File.file?(File.join(sql_scripts_dir, f)) }
end

# Extracts numbers from the script names
def get_numbers(strings)
  strings.map do |s|
    s.scan(/\d+/).first.to_i
  end
end

private

def get_num(string)
  string.scan(/\d+/).first.to_i
end

#
# if ARGV.length != 5
#   puts 'Usage: ./DB_upgrade dir user host db_name db_password'
#   exit(1)
# end
#
# dir = ARGV[0]
# db_username = ARGV[1]
# db_host = ARGV[2]
# db_name = ARGV[3]
# db_password = ARGV[4]
#
#
# upgrade_db(dir, db_username, db_host, db_name, db_password)
