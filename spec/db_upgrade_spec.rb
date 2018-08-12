# frozen_string_literal: true

require_relative '../lib/DB_upgrade.rb'

describe 'DB upgrade' do

  describe '#lookup_current_db_version' do
    it 'Looks up the current version number' do
      expect(lookup_current_db_version).to eq 45
    end
  end

  describe '#'

  xdescribe '#compare_version_nums'


 end
