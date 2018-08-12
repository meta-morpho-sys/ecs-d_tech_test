# frozen_string_literal: true

RSpec.configure do |c|
   # The following will roll back the transactions
  # after each example has been run.
  c.around(:example, :db) do |example|
    puts 'Rolling back transaction'
    DB.transaction(rollback: :always) { example.run }
  end
end
