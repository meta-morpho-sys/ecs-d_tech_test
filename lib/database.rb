#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../logs/logging'
require_relative 'script'
require_relative '../spec/support/db'

# --------------------------------------------------------------------------
# Connects to MySQL database and carries out changes on the database schema.
# It takes five parameters during its initialisation
#   -dir --> a rel. or abs path to a directory with numbered SQL scripts,
#   -user --> database username
#   -host --> host
#   -database --> database name
#   -pwd --> your password for the database
# --------------------------------------------------------------------------
class Database
  attr_reader :db

  LOGGER = my_logger

  def initialize(db = nil, **db_conn_info)
    @dir = db_conn_info[:dir]
    begin
      @db = db || get_db(db_conn_info)
      set_version_table
    rescue Sequel::DatabaseConnectionError
      LOGGER.info('Incorrect access details')
      exit 1
    end
  end

  def set_version_table
    unless @db.table_exists? 'versionTable'
      @db.create_table :versionTable do
        Integer :version
        LOGGER.info 'Version table created'
      end
    end
    @versions = @db[:versionTable]
    @versions.insert(version: 0)
  end

  def version
    @versions.map(:version).first
  end

  def version=(version)
    @versions.update(version: version)
  end

  def run(script)
    sql = script.read
    @db.run sql
  end

  def upgrade
    current_db_version = version
    LOGGER.info("Current DB version is #{current_db_version}")

    # Get highest script version
    begin
      scripts = Scripts.look_up(@dir).sort_by(&:version)
      max_version = scripts.last.version
      LOGGER.info("Max script version is #{max_version}")
      # Run only scripts with version higher than the DB version.
      if max_version > current_db_version
        LOGGER.info 'updating...'
        run_scripts(current_db_version, scripts)

        self.version = max_version
        LOGGER.info "New DB version: #{version}"
      else
        LOGGER.info 'DB up to date'
      end
    rescue
      LOGGER.info("No scripts found in #{@dir}, the database hasn't been upgraded.")
    end
  end

  def run_scripts(current_db_version, scripts)
    scripts_to_run = scripts.select { |s| s.version > current_db_version }
    scripts_to_run.each do |s|
      run(s)
      LOGGER.info "Running script #{s.file_path}..."
      LOGGER.info '...done ;-)'
    end
  end
end
