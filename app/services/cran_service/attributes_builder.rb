# frozen_string_literal: true

module CranService
  class AttributesBuilder
    def self.call(dcf_hash)
      new(dcf_hash).call
    end

    def initialize(dcf_hash)
      @dcf_hash = dcf_hash
    end

    def call
      raise Errors::InvalidDcfHashError, dcf_hash unless invalid_dcf_hash?

      { name: name,
        version: version,
        authors: authors,
        date_publication_at: date_publication_at,
        dependencies: dependencies,
        license: license,
        maintainers: maintainers,
        required_r_version: required_r_version,
        title: title }
    end

    private

    attr_reader :dcf_hash

    def invalid_dcf_hash?
      dcf_hash.present? && dcf_hash.is_a?(Hash)
    end

    def name
      dcf_hash["Package"]
    end

    def version
      dcf_hash["Version"]
    end

    def required_r_version
      dcf_hash.key?("Depends") ? dcf_hash["Depends"][/R\ \((.*?)\)/] : nil
    end

    def dependencies
      dcf_hash.key?("Depends") ? dcf_hash["Depends"].split(",").map(&:strip) : nil
    end

    def date_publication_at
      DateTime.parse(dcf_hash["Date/Publication"])
    end

    def title
      dcf_hash["Title"].gsub("\n", " ")
    end

    def authors
      return [] if dcf_hash["Author"].blank?

      dcf_hash["Author"]
        .gsub(/\[.*?\]/, "") # remove square brackets and there contents
        .gsub("\n", "")      # remove new lines
        .strip               # remove leading and trailing whitespace
        .squeeze(" ")        # remove duplicate spaces
        .split(",")          # split on commas
        .map(&:strip)        # remove leading and trailing whitespace from splitting on commas
    end

    def maintainers
      dcf_hash["Maintainer"].split(",")
    end

    def license
      dcf_hash["License"]
    end
  end
end
