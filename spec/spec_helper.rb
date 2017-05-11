ENV['RAILS_ENV'] ||= 'test'

require 'dotenv/load'
require 'bundler/setup'
require 'vcr'

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
  SimpleCov.refuse_coverage_drop
end

require 'global_reach_partners'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/cassettes'
  c.configure_rspec_metadata!
  c.default_cassette_options = {
    match_requests_on: %i[method path]
  }
end

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    GlobalReachPartners.configure do |config|
      config.url = ENV['URL']
      config.client_code = ENV['CLIENT_CODE']
      config.username = ENV['USERNAME']
      config.password = ENV['PASSWORD']
      config.debug = true
    end
  end
end
