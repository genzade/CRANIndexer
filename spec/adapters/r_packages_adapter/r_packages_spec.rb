# frozen_string_literal: true

require "rails_helper"

RSpec.describe RPackagesAdapter::RPackages do
  before do
    base_url = Rails.application.config_for(:cran).fetch(:base_url)

    allow(URI).to receive(:parse)
      .with("#{base_url}PACKAGES")
      .and_return(
        double(
          open: double(
            read: file_fixture("cran_packages_raw_md").read
          )
        )
      )
  end

  describe "#package_urls" do
    it "returns a list of all packages download urls" do
      r_packages = RPackagesAdapter::RPackages.new
      expect(r_packages.package_urls).to contain_exactly(
        "https://cran.r-project.org/src/contrib/Ac3net_1.2.2.tar.gz",
        "https://cran.r-project.org/src/contrib/abc.data_1.0.tar.gz",
        "https://cran.r-project.org/src/contrib/abtest_1.0.1.tar.gz",
        "https://cran.r-project.org/src/contrib/accept_1.0.0.tar.gz",
        "https://cran.r-project.org/src/contrib/BANOVA_1.2.1.tar.gz",
        "https://cran.r-project.org/src/contrib/GDAtools_2.0.tar.gz",
        "https://cran.r-project.org/src/contrib/GenOrd_1.4.0.tar.gz",
        "https://cran.r-project.org/src/contrib/abbyyR_0.5.5.tar.gz",
        "https://cran.r-project.org/src/contrib/bundle_0.1.0.tar.gz",
        "https://cran.r-project.org/src/contrib/varbin_0.2.1.tar.gz"
      )
    end
  end
end
