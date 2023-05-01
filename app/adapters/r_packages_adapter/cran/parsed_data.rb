# frozen_string_literal: true

require "open-uri"
require "control_file_parser"

module RPackagesAdapter
  module Cran
    class ParsedData
      def self.call
        new.call
      end

      def call
        ControlFileParser.parse(raw_cran_packages.read)
      end

      private

      def raw_cran_packages
        base_url = Rails.application.config_for(:cran).fetch(:base_url)
        @raw_cran_packages ||= URI.parse("#{base_url}PACKAGES").open
      end
    end
  end
end
