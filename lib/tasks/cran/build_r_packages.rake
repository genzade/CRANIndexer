# frozen_string_literal: true

module Tasks
  module Cran
    class BuildRPackages
      include Rake::DSL

      def initialize
        namespace :cran do
          namespace :build_r_packages do
            desc "task to build r packages from the CRAN server"
            task run: [:environment] do
              Adapter.r_packages.package_urls.each do |package_url|
                package_builder = CranService::PackageBuilder.new(package_url)

                package_builder.call
              end
            end
          end
        end
      end
    end
  end
end

Tasks::Cran::BuildRPackages.new
