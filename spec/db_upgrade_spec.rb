# frozen_string_literal: true

require_relative '../lib/DB_upgrade.rb'

describe 'DB upgrade' do

  describe '#lookup_current_db_version' do
    it 'Looks up the current version number' do
      expect(lookup_current_db_version).to eq 45
    end
  end

  describe '#scan_scripts_names' do
    it '# scans the scripts folder and returns a collection of script names' do
      dir_name = 'db/upgrade_scripts'
      expect(scan_scripts_names(dir_name)).to include('045.createtable.sql', '049.createtable.sql','011createtable.sql')
    end
  end

  describe '#find_highest_scirpt_number' do
    pending 'finds the highest script number among the sql scripts'
  end

  describe '#compare_version_nums' do
    pending 'Compares the current version against the scripts numbers'
  end
end
