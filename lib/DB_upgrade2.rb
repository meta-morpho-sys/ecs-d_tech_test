#!/usr/bin/env ruby
# frozen_string_literal: true

require 'sequel'
require_relative 'logging'
require_relative 'script'

# --------------------------------------------------------------------------
# Connects to MySQL database and carries out changes on the database schema.
# It takes five parameters during its initialisation
#   -dir --> a rel. or abs path to a directory with numbered SQL scripts,
#   -user --> database username
#   -host --> host
#   -database --> database name
#   -pwd --> your password for the database
# --------------------------------------------------------------------------
class DatabaseMigrations
  LOGGER = my_logger

  def initialize(dir, user, host, database, pwd)
    @dir = dir
    @db = Sequel.mysql2(host: host, database: database, user: user, password: pwd)
    unless @db.table_exists? 'versionTable'
      @db.create_table :versionTable do
        Integer :version
        LOGGER.info 'Version table created'
      end
    end
    @versions = @db[:versionTable]
    @versions.insert(version: 0)
  end

  def db_version
    @versions.map(:version).first
  end

  def db_version=(version)
    @versions.update(version: version)
  end

  def run(script)
    sql = script.read
    @db.run sql
  end

  def upgrade_db
    current_db_version = db_version
    LOGGER.info("Current DB version is #{current_db_version}")

    # Get highest script version
    scripts = Scrypts.look_up(@dir).sort_by(&:version)
    max_version = scripts.last.version
    LOGGER.info("Max script version is #{max_version}")

    # Run only scripts with version higher than the DB version.
    if max_version > current_db_version
      LOGGER.info 'updating...'
      scripts_to_run = scripts.select { |s| s.version > current_db_version }
      scripts_to_run.each do |s|
        run(s)
        LOGGER.info"Running script #{s.file_path}..."
        LOGGER.info '...done ;-)'
      end
      self.db_version = max_version
      LOGGER.info "New DB version: #{db_version}"
    else
      LOGGER.warn 'DB up to date'
    end
  end
end
