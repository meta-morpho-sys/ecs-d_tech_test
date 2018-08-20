# frozen_string_literal: true

require_relative '../lib/script'

describe Scrypts do
  it 'finds scripts in given directory' do
    expect(Dir).to receive(:entries)
      .with('db/upgrade_scripts')
      .and_return(%w[045.createtable.sql 011createtable.sql 049.createtable.sql])
    Scrypts.look_up('db/upgrade_scripts')
  end
end

describe Scrypt do
  let(:scrypt) { Scrypt.new('db/upgrade_scripts', '049.createtable.sql') }

  it 'finds the file path' do
    expect(scrypt.file_path). to eq 'db/upgrade_scripts/049.createtable.sql'
  end

  it 'reads the file contents' do
    expect(scrypt.read). to eq <<~EOF
      CREATE TABLE test (
        participant VARCHAR(20),
        age INTEGER(2),
        scripting_language VARCHAR(20)
      );
    EOF
  end

  describe '#version' do
    it 'extracts the script numbers from the file names' do
      expect(scrypt.version).to eq 49
    end
  end
end
