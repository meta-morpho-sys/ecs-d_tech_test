# frozen_string_literal: true

require_relative '../lib/DB_upgrade2.rb'

describe Database, :db do

  let(:dtb) { Database.new '../db/upgrade_scripts', 'root', 'localhost', 'test' , 'yuliya' }

  describe '#version' do
    it 'Looks up the current version number' do
      expect(dtb.version).not_to eq nil
    end
  end

  describe '#run' do
    it 'gives the DB the content of a script to run' do
      allow(Dir)
        .to receive(:entries)
        .and_return(%w[045.createtable.sql])
      expect(DB).to receive(:run)
      dtb.run'045.createtable.sql'
    end
  end

  xdescribe '#select_higher_versions' do
    it 'picks files that have version number greater than the current db version' do
      dir = 'db/upgrade_scripts'
      upgrade = double('DB_Upgrade', current_db_version: 11)
      allow(upgrade).to receive(:current_db_version).and_return(11)
      expect(select_higher_versions(dir))
        .to include('045.createtable.sql', '049.createtable.sql')
    end
  end

  xdescribe '#upgrade_db' do
    it 'the current version is equal to the highest of the scripts numbers' do
      allow(Dir)
        .to receive(:entries)
        .and_return(%w[045.createtable.sql 011createtable.sql])
      expect(db.upgrade('db/upgrade_scripts', 'root', 'lochi', 'test', 'yul'))
        .to eq 'DB up to date!'
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
