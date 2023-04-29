# frozen_string_literal: true

module RPackagesAdapter
  module Cran
    class DataMapper
      def self.map_in_batches(batch_size, &)
        new.map_in_batches(batch_size, &)
      end

      def map_in_batches(batch_size, &block)
        result = []
        cran_packages.each_slice(batch_size) do |batch|
          batch.each { |hash| result << block.call(hash) }
        end
        result
      end

      private

      def cran_packages
        @cran_packages ||= RPackagesAdapter::Cran::ParsedData.call
      end
    end
  end
end
