# frozen_string_literal: true

require "rails_helper"

RSpec.describe RPackagesAdapter::Cran::Errors::InvalidPackageError do
  describe "#message" do
    it "returns correct message" do
      error = RPackagesAdapter::Cran::Errors::InvalidPackageError.new

      expect(error.message).to eq("Package hash does not contain Package or Version key")
    end
  end
end
