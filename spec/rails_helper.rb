ENV['RAILS_ENV'] ||= 'test'

require 'spec_helper'
require_relative '../config/environment'
require 'rspec/rails'

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.infer_spec_type_from_file_location!

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
