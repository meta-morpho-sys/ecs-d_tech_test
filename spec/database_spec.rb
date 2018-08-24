# frozen_string_literal: true

require_relative '../lib/database.rb'
require_relative '../spec/support/db'

describe Database, :db do

  let(:dtb) { Database.new DB }

  describe 'initialize' do
    it 'Database class can be initialized with existing db connection' do
      # for example connection established in support/db.rb - assigned to DB
      expect(dtb.db.test_connection).to eq true
    end

    it 'Database class can be initialized with options hash' do
      db_info = { dir: '../db/upgrade_scripts', user: 'root', host: 'localhost', database: 'test', password: 'yuliya'}
      dtb2 = Database.new db_info
      expect(dtb2.db.test_connection).to eq true
    end
  end

  describe '#version' do
    it 'Looks up the current version number' do
      expect(dtb.version).not_to eq nil
    end
  end

  describe '#version=' do
    it 'sets the versionTable to a new value' do
      dtb.version = 22
      expect(dtb.version).to eq 22
    end
  end

  describe '#run' do
    it 'passes the scripts to the Sequel gem to run' do
      scripts = Scripts.look_up('db/upgrade_scripts')
      expect(dtb.db).to receive(:run).exactly(3).times
      scripts.each { |s| dtb.run s }
    end
  end
end
