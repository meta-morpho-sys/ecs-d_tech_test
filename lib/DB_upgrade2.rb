#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../db/sequel_setup'


VERSION_TABLE = DB[:versionTable]

def current_db_version
  VERSION_TABLE.map(:version).first
end

def upgrade_db(dir, user, host, database, pswd)
  if get_highest_script_num(dir) > current_db_version
    # Updates DB
    # Run those files that are higher version than Current DB version
    files_to_run = select_higher_versions(dir)
    files_to_run.each { |file| DB.run File.read dir + '/' + file }
    VERSION_TABLE.update(version: get_highest_script_num(dir))
  else
    'DB up to date!'
  end
end

def select_higher_versions(dir)
  scan_scripts_names(dir).select do |name|
    version(name) > current_db_version
  end
end

def get_highest_script_num(dir)
  get_versions(scan_scripts_names(dir)).max
end


# Returns a collection of script versions
def get_versions(strings)
  strings.map { |s| version(s) }
end

# returns the version of the script
def version(str)
  str[/\d+/].to_i
end
