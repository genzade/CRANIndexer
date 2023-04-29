# frozen_string_literal: true

module CranService
  class PackageResolver
    def self.call(package_attrs)
      new(package_attrs).call
    end

    def initialize(package_attrs)
      @package_attrs = package_attrs
    end

    def call
      return if package_exists?

      package = Package.new(package_attrs)

      package.save!
    end

    private

    attr_reader :package_attrs

    def package_exists?
      Package.find_by(
        name: package_attrs[:name],
        version: package_attrs[:version]
      ).present?
    end
  end
end
