# frozen_string_literal: true

require_relative '../lib/DB_upgrade.rb'

describe DBUpgrade do
  let(:upgrade) { DBUpgrade.new }

  describe '#lookup_current_db_version' do
    it 'Looks up the current version number' do
      expect(upgrade.lookup_current_db_version).to eq 45
    end
  end

  describe '#scan_scripts_names' do
    it '# scans the scripts folder and returns a collection of script names' do
      dir_name = 'db/upgrade_scripts'
      expect(upgrade.scan_scripts_names(dir_name))
        .to include('045.createtable.sql', '049.createtable.sql', '011createtable.sql')
    end
  end

  describe '#db_status' do
    it 'the current version is equal to the highest of the scripts numbers' do
      allow(Dir).to receive(:entries)
                      .and_return(%w[045.createtable.sql 011createtable.sql])
      dir_name = 'db/upgrade_scripts'
      expect(upgrade.db_status(dir_name)).to eq 'DB up to date!'
    end

    it 'and the current version is lower than the highest of the scripts numbers' do
      dir_name = 'db/upgrade_scripts'
      expect(upgrade.db_status(dir_name)).to eq 'Upgrade your DB!'
    end
  end
end
