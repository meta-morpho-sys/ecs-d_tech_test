# frozen_string_literal: true

require_relative '../db/sequel_setup'

class DBUpgrade
  VERSION_TABLE = DB[:versionTable]

  def initialize(sql_scripts_dir, db_username, db_host, db_name, db_password)
    @sql_scripts_dir = sql_scripts_dir
    @db_username = db_username
    @db_host = db_host
    @db_name = db_name
    @db_password = db_password
  end

  def lookup_current_db_version
    VERSION_TABLE.map(:version).first
  end

  def upgrade_db
    highest_script_v = scan_scripts_names.max.scan(/\d+/).first.to_i
    if highest_script_v > lookup_current_db_version
      DB.run File.read('/Users/astarte/TechTests/ECS-D/db/upgrade_scripts/049.createtable.sql')
      VERSION_TABLE.update(version: highest_script_v)
    else
      'DB up to date!'
    end
  end

  def scan_scripts_names
    Dir.entries(@sql_scripts_dir)
      .select { |f| File.file?(File.join(@sql_scripts_dir, f)) }
  end
end
