# frozen_string_literal: true

require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'

abort('The Rails environment is running in production mode!') if Rails.env.production?

require 'refinements'
require 'rspec/rails'
require 'shoulda-matchers'
require 'vcr'
require 'webmock/rspec'

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

VCR.configure do |config|
  config.ignore_localhost = true
  config.cassette_library_dir = Rails.root.join('spec/cassettes')
  config.hook_into :webmock
  config.configure_rspec_metadata!
end

WebMock.disable_net_connect!(allow_localhost: true)

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

using Refinements::Pathnames
Pathname.require_tree __dir__, 'support/shared_contexts/**/*.rb'

FactoryBot.definition_file_paths = [Bundler.root.join('spec/factories')]
FactoryBot.find_definitions

RSpec.configure do |config|
  config.include ActiveSupport::Testing::TimeHelpers
  config.include FactoryBot::Syntax::Methods

  config.use_transactional_fixtures = true

  config.filter_rails_from_backtrace!
  config.infer_spec_type_from_file_location!

  config.around do |example|
    if example.metadata[:vcr]
      VCR.turn_on!
      example.run
      VCR.turn_off!
    else
      VCR.turn_off!
      example.run
      VCR.turn_on!
    end
  end

  config.before do
    WebMock.reset!

    FileUtils.rm_rf(ActiveStorage::Blob.service.root)
  end
end
