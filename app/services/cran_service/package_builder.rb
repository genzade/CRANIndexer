# frozen_string_literal: true

require "open-uri"
require "rubygems/package"

module CranService
  class PackageBuilder
    def initialize(package_url)
      @package_url = package_url
    end

    def call
      zfile = Zlib::GzipReader.new(package_file)

      Gem::Package::TarReader.new(zfile).seek("#{package_name}/DESCRIPTION") do |entry|
        dcf_hash ||= DebControl::ControlFileBase.parse(entry.read).first
        package_attrs = build_attributes(dcf_hash)

        create_package(package_attrs)
      end
    rescue Zlib::GzipFile::Error => e
      Rails.logger.debug { "Error: #{e.message}" }
    end

    private

    attr_reader :package_url

    def package_file
      @package_file ||= URI.parse(package_url).open
    end

    def package_name
      package_url.split("/").last.split("_").first
    end

    def build_attributes(dcf_hash)
      CranService::AttributesBuilder.call(dcf_hash)
    end

    def create_package(package_attrs)
      CranService::PackageResolver.call(package_attrs)
    end
  end
end
