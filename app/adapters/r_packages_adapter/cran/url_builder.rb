# frozen_string_literal: true

module RPackagesAdapter
  module Cran
    class UrlBuilder
      GZIP_EXTENTION = ".tar.gz"
      REQUIRED_KEYS = %w[Package Version].freeze

      def self.call(package)
        new(package).call
      end

      def initialize(package)
        @package = package
      end

      def call
        raise RPackagesAdapter::Cran::Errors::EmptyPackageError if package.empty?

        raise RPackagesAdapter::Cran::Errors::InvalidPackageError unless package_includes_required_keys?

        [
          Rails.application.config_for(:cran).fetch(:base_url),
          formatted_package_name,
          GZIP_EXTENTION
        ].join
      end

      private

      attr_reader :package

      def formatted_package_name
        package.values_at(*REQUIRED_KEYS).join("_")
      end

      def package_includes_required_keys?
        package.keys.include?("Package") && package.keys.include?("Version")
      end
    end
  end
end
