# frozen_string_literal: true

module RPackagesAdapter
  module Cran
    module Errors
      class EmptyPackageError < StandardError
        def message
          "Package hash is empty"
        end
      end
    end
  end
end
