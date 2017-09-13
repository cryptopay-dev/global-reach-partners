ENV['RAILS_ENV'] ||= 'test'

require 'dotenv/load'
require 'bundler/setup'
require 'pry-byebug'
require 'webmock/rspec'
require 'vcr'

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
  SimpleCov.refuse_coverage_drop
end

require 'global_reach_partners'

VCR.configure do |c|
  c.cassette_library_dir = './spec/fixtures/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!

  c.default_cassette_options = {
    match_requests_on: %i[method path]
  }

  c.filter_sensitive_data('<GRP_CLIENT_CODE>') { ENV['GRP_CLIENT_CODE'] }
  c.filter_sensitive_data('<GRP_USERNAME>') { ENV['GRP_USERNAME'] }
  c.filter_sensitive_data('<GRP_PASSWORD>') { ENV['GRP_PASSWORD'] }
end

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    GlobalReachPartners.configure do |config|
      config.url = ENV['GRP_URL']
      config.client_code = ENV['GRP_CLIENT_CODE']
      config.username = ENV['GRP_USERNAME']
      config.password = ENV['GRP_PASSWORD']
      config.debug = ENV['GRP_DEBUG'] == 'true'
    end
  end
end
