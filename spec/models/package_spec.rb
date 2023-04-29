# frozen_string_literal: true

require "rails_helper"

RSpec.describe Package, type: :model do
  it { is_expected.to validate_presence_of(:name) }

  describe "#download_url" do
    it "returns a url with package name and version" do
      package = create(:package, name: "test_package", version: "0.1.0")
      expect(package.download_url)
        .to eq("#{Rails.application.config_for(:cran).fetch(:base_url)}test_package_0.1.0.tar.gz")
    end
  end
end
