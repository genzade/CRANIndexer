# frozen_string_literal: true

module RPackagesAdapter
  module Cran
    module Errors
      class InvalidPackageError < StandardError
        def message
          "Package hash does not contain Package or Version key"
        end
      end
    end
  end
end
