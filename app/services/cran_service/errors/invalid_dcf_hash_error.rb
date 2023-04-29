# frozen_string_literal: true

module CranService
  module Errors
    class InvalidDcfHashError < StandardError
      def initialize(dcf_hash)
        super("Invalid dcf hash: `#{dcf_hash}`")
      end
    end
  end
end
