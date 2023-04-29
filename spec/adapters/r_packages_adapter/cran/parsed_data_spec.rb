# frozen_string_literal: true

require "rails_helper"

RSpec.describe RPackagesAdapter::Cran::ParsedData do
  before do
    base_url = Rails.application.config_for(:cran).fetch(:base_url)
    uri_instance = instance_double(URI::HTTP, open: file_fixture("cran_packages_raw_sm"))

    allow(URI).to receive(:parse)
      .with("#{base_url}PACKAGES")
      .and_return(uri_instance)
  end

  describe "#call" do
    it "parses" do
      expect(RPackagesAdapter::Cran::ParsedData.call).to contain_exactly(
        a_hash_including("Package" => "A3",       "Version" => "1.0.0"),
        a_hash_including("Package" => "cultevo",  "Version" => "1.0.2"),
        a_hash_including("Package" => "cumprinc", "Version" => "0.1"),
        a_hash_including("Package" => "cumSeg",   "Version" => "1.3"),
        a_hash_including("Package" => "cuperdec", "Version" => "1.1.0")
      )
    end
  end
end
