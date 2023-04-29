# frozen_string_literal: true

require "rails_helper"

RSpec.describe RPackagesAdapter::Cran::UrlBuilder do
  describe "#call" do
    it "returns a url to an R package" do
      package = {
        "Package" => "package_name",
        "Version" => "1.0.0"
      }
      url_bulder = RPackagesAdapter::Cran::UrlBuilder.new(package)

      expect(url_bulder.call).to eq(
        "#{Rails.application.config_for(:cran).fetch(:base_url)}package_name_1.0.0.tar.gz"
      )
    end

    context "when empty package hash passed" do
      it "returns a url to an R package" do
        package = {}
        url_bulder = RPackagesAdapter::Cran::UrlBuilder.new(package)

        expect { url_bulder.call }.to raise_error(
          RPackagesAdapter::Cran::Errors::EmptyPackageError,
          "Package hash is empty"
        )
      end
    end

    context "when package hash without Package key passed" do
      it "returns a url to an R package" do
        package = { "Version" => "1.0.0" }
        url_bulder = RPackagesAdapter::Cran::UrlBuilder.new(package)

        expect { url_bulder.call }.to raise_error(
          RPackagesAdapter::Cran::Errors::InvalidPackageError,
          "Package hash does not contain Package or Version key"
        )
      end
    end

    context "when package hash without Version key passed" do
      it "returns a url to an R package" do
        package = { "Package" => "package_name" }
        url_bulder = RPackagesAdapter::Cran::UrlBuilder.new(package)

        expect { url_bulder.call }.to raise_error(
          RPackagesAdapter::Cran::Errors::InvalidPackageError,
          "Package hash does not contain Package or Version key"
        )
      end
    end
  end
end
