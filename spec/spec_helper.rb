require 'pry'
require 'simplecov'
require 'yaml'

SimpleCov.start do
  add_filter '/spec'
  add_filter '/vendor'
end

require 'perambulator'

Perambulator.configure do |config|
  config.env = 'test'
  config.aws.credentials = Aws::SharedCredentials.new(profile_name: 'perambulator-test')
  config.kms.key_arn = 'arn:aws:kms:us-east-1:646056346310:key/df369aa2-8da1-4516-9df6-243fb3543480'
  config.load_local_kv(
    Pathname.new(__dir__).join('support', 'files', 'local_kv.yml'),
    Pathname.new(__dir__).join('support', 'tmp')
  )
end

RSpec.configure do |config|
  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
