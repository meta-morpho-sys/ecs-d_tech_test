# frozen_string_literal: true

require_relative '../lib/DB_upgrade.rb'

describe DBUpgrade, :db do
  let(:upgrader) { DBUpgrade.new('db/upgrade_scripts', 'root', 'localhost', 'test', 'yuliya') }

  describe '#lookup_current_db_version' do
    it 'Looks up the current version number' do
      expect(upgrader.lookup_current_db_version).to eq 49
    end
  end

  describe '#scan_scripts_names' do
    it '# scans the scripts folder and returns a collection of script names' do
      expect(upgrader.scan_scripts_names)
        .to include('045.createtable.sql', '049.createtable.sql', '011createtable.sql')
    end
  end

  describe '#upgrade_db' do
    it 'the current version is equal to the highest of the scripts numbers' do
      allow(Dir)
        .to receive(:entries)
        .and_return(%w[045.createtable.sql 011createtable.sql])
      expect(upgrader.upgrade_db).to eq 'DB up to date!'
    end

    it 'and the current version is lower than the highest of the scripts numbers' do
      allow(Dir)
        .to receive(:entries)
              .and_return(%w[045.createtable.sql 011createtable.sql 049.createtable.sql])
      upgrader.upgrade_db
      expect(upgrader.lookup_current_db_version).to eq 49
    end
  end
end
