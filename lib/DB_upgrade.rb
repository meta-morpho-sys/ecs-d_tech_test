# frozen_string_literal: true

require_relative '../db/sequel_setup'

def lookup_current_db_version
  DB[:versionTable].map(:version).first
end

def scan_scripts_names(path)
  Dir.entries(path).select { |f| File.file?(File.join(path, f)) }
end

def find_highest_script_number(script_names)
  script_names.max
end
