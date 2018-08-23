# frozen_string_literal: true

require_relative '../lib/database.rb'
require_relative '../spec/support/db'

describe Database, :db do
  db_info = { dir: '../db/upgrade_scripts', user: 'root', host: 'localhost', database: 'test', password: 'yuliya'}

  let(:dtb) { Database.new db_info }

  describe 'initialize' do
    it 'Database class can be initialized with keyword args' do
      dtb.version = 22
      expect(dtb.db.test_connection).to eq true
      expect(dtb.version).to eq 22
    end

    it 'Database class can be initialized with existing db connection' do
      # for example connection established in support/db.rb - assigned to DB
      other_dtb = Database.new DB
      expect(other_dtb.db.test_connection).to eq true
    end
  end

  describe '#version' do
    it 'Looks up the current version number' do
      expect(dtb.version).not_to eq nil
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
