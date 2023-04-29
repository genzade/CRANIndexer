# frozen_string_literal: true

module RPackagesAdapter
  module Cran
    class UrlListBuilder
      BATCH_SIZE = 100

      def self.build
        new.build
      end

      def build
        RPackagesAdapter::Cran::DataMapper.map_in_batches(
          BATCH_SIZE,
          &method(:build_package_url)
        )
      end

      private

      def build_package_url(package)
        RPackagesAdapter::Cran::UrlBuilder.call(package)
      end
    end
  end
end
