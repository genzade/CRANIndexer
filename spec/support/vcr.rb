# frozen_string_literal: true

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
end

RSpec.configure do |config|
  config.around(:each, :vcr) do |example|
    VCR.use_cassette(example.metadata[:vcr]) { example.call }
  end
end
