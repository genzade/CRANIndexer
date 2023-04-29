# frozen_string_literal: true

module RPackagesAdapter
  class RPackages
    def package_urls
      RPackagesAdapter::Cran::UrlListBuilder.build
    end
  end
end
