# frozen_string_literal: true

require_relative '../lib/script'

describe Scripts do
  it 'finds scripts in given directory' do
    expect(Dir).to receive(:entries)
      .with('db/upgrade_scripts')
      .and_return(%w[045.createtable.sql 011createtable.sql 049.createtable.sql])
    Scripts.look_up('db/upgrade_scripts')
  end

  it 'returns a list of scripts for directory' do
    scripts = Scripts.look_up('db/upgrade_scripts')
    file_names = scripts.map(&:file_name)
    expect(file_names).to eq(%w[045.createtable.sql 011createtable.sql 049.createtable.sql])
  end
end

describe Script do
  let(:script) { Script.new('db/upgrade_scripts', '049.createtable.sql') }

  it 'finds the file path' do
    expect(script.file_path). to eq 'db/upgrade_scripts/049.createtable.sql'
  end

  it 'reads the file contents' do
    expect(script.read). to eq <<~EOF
      CREATE TABLE test (
        participant VARCHAR(20),
        age INTEGER(2),
        scripting_language VARCHAR(20)
      );
    EOF
  end

  describe '#version' do
    it 'extracts the script numbers from the file names' do
      expect(script.version).to eq 49
    end
  end
end
