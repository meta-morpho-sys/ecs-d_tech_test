# frozen_string_literal: true

require_relative '../lib/script'

describe Scrypts do
  it 'finds scripts in given directory' do
    expect(Scrypts.look_up('db/upgrade_scripts'))
      .to include('045.createtable.sql', '011createtable.sql', '049.createtable.sql')
  end
end

describe Scrypt do
  let(:scrypt) { Scrypt.new('db/upgrade_scripts', '049.createtable.sql')}
  it 'finds the file path' do
    expect(scrypt.file_path). to eq 'db/upgrade_scripts/049.createtable.sql'
  end

  it 'reads the file contents' do
    expect(scrypt.read). to eq 'CREATE TABLE test (
  participant VARCHAR(20),
  age INTEGER(2),
  scripting_language VARCHAR(20)
);
'
  end
end
