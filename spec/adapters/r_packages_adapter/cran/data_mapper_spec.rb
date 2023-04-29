# frozen_string_literal: true

require "rails_helper"

RSpec.describe RPackagesAdapter::Cran::DataMapper do
  describe "#map_in_batches" do
    it "yields block" do
      data_mapper = RPackagesAdapter::Cran::DataMapper.new
      parsed_data = [
        { "Package" => "A3",       "Version" => "1.0.0" },
        { "Package" => "cultevo",  "Version" => "1.0.2" },
        { "Package" => "cumprinc", "Version" => "0.1" },
        { "Package" => "cumSeg",   "Version" => "1.3" },
        { "Package" => "cuperdec", "Version" => "1.1.0" }
      ]

      allow(RPackagesAdapter::Cran::ParsedData).to receive(:call)
        .and_return(parsed_data)

      expect { |block| data_mapper.map_in_batches(5, &block) }.to yield_control
        .at_most(5).times
    end
  end
end
