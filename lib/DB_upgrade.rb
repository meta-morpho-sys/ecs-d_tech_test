# frozen_string_literal: true

require_relative '../db/sequel_setup'

def lookup_current_db_version
  DB[:versionTable].map(:version).first
end
