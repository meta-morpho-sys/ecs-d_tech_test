# frozen_string_literal: true

require_relative '../db/sequel_setup'

def lookup_current_db_version
  DB[:versionTable].map(:version).first
end

def scan_scripts_names(path)
  Dir.entries(path).select { |f| File.file?(File.join(path, f)) }
end

def db_status(path)
  current_bd_v = lookup_current_db_version
  highest_script_v = scan_scripts_names(path).max.scan(/\d+/).first.to_i
  if highest_script_v > current_bd_v
    'Upgrade your DB!'
  else
    'DB up to date!'
  end
end
