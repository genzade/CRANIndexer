# frozen_string_literal: true

require "rails_helper"

RSpec.describe RPackagesAdapter::Cran::Errors::EmptyPackageError do
  describe "#message" do
    it "returns correct message" do
      error = RPackagesAdapter::Cran::Errors::EmptyPackageError.new

      expect(error.message).to eq("Package hash is empty")
    end
  end
end
