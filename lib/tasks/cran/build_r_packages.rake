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
              Adapter.r_packages.package_urls.in_groups_of(100, false) do |package_urls|
                package_urls.each do |package_url|
                  package_builder = CranService::PackageBuilder.new(package_url)

                  ActiveRecord::Base.transaction { package_builder.call }
                rescue SocketError => e
                  puts "package_url: #{package_url}, Error: #{e.message}"
                end
              end
            end
          end
        end
      end
    end
  end
end

Tasks::Cran::BuildRPackages.new
