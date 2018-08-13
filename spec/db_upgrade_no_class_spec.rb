# frozen_string_literal: true

require_relative '../lib/DB_upgrade_no_class.rb'

describe 'DB_upgrade', :db do

  # let(:result) { upgrade_db('db/upgrade_scripts', 'root', 'localhost', 'test', 'yuliya') }

  describe '#lookup_current_db_version' do
    it 'Looks up the current version number' do
      upgrade = double('DB_Upgrade', current_db_version: 11)
      expect(upgrade).to receive(:current_db_version).and_return(11)
      upgrade.current_db_version
    end
  end

  describe '#scan_scripts_names' do
    it '# scans the scripts folder and returns a collection of script names' do
      dir = 'db/upgrade_scripts'
      expect(scan_scripts_names(dir))
        .to include('045.createtable.sql', '049.createtable.sql', '011createtable.sql')
    end
  end

  describe '#script_numbers' do
    it 'extracts the script numbers from the file names' do
      file_names = %w[045.createtable.sql 011createtable.sql 049.createtable.sql]
      expect(get_numbers(file_names)).to include(45, 11, 49)
    end
  end

  describe '#select_higher_versions' do
    it 'picks files that have version number greater than the current db version' do
      allow(upgrader).to receive(:current_db_version).and_return(11)
      expect(select_higher_versions)
        .to include('045.createtable.sql', '049.createtable.sql')
    end
  end

  describe '#upgrade_db' do
    let(:result) { upgrade_db('db/upgrade_scripts', 'root', 'localhost', 'test', 'yuliya') }
    it 'the current version is equal to the highest of the scripts numbers' do
      allow(Dir)
        .to receive(:entries)
        .and_return(%w[045.createtable.sql 011createtable.sql])
      expect(result).to eq 'DB up to date!'
    end

    it 'the current version is lower than the highest of the scripts numbers' do
      allow(Dir)
        .to receive(:entries)
        .and_return(%w[045.createtable.sql 011createtable.sql 049.createtable.sql])
      result
      expect(current_db_version).to eq 49
    end
  end
end
