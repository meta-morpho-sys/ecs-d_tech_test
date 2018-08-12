# frozen_string_literal: true

require_relative '../db/sequel_setup'

def lookup_db_version
  print 'hello'
  DB[:versionTable].map(:version).first
end
