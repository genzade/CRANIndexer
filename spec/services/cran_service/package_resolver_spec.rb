# frozen_string_literal: true

require "rails_helper"

RSpec.describe CranService::PackageResolver do
  context "when package does not exist" do
    it "creates a new package" do
      attrs = { name: "A3", version: "0.9.2" }
      package_resolver = CranService::PackageResolver.new(attrs)

      expect { package_resolver.call }.to change(Package, :last)
        .from(nil)
        .to(
          an_object_having_attributes(
            name: "A3",
            version: "0.9.2"
          )
        )
    end
  end

  context "when package already exists" do
    it "does not create a new package" do
      create(:package, name: "A3", version: "0.9.2")

      attrs = { name: "A3", version: "0.9.2" }
      package_resolver = CranService::PackageResolver.new(attrs)

      expect { package_resolver.call }.not_to change(Package, :last)
    end
  end
end
