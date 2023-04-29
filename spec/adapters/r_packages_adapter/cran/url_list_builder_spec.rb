# frozen_string_literal: true

require "rails_helper"

RSpec.describe RPackagesAdapter::Cran::UrlListBuilder do
  before do
    base_url = Rails.application.config_for(:cran).fetch(:base_url)

    allow(URI).to receive(:parse)
      .with("#{base_url}PACKAGES")
      .and_return(
        double(
          open: double(
            read: file_fixture("cran_packages_raw_sm").read
          )
        )
      )
  end

  describe "#build" do
    it "yields block" do
      url_list_builder = RPackagesAdapter::Cran::UrlListBuilder.new

      expect(url_list_builder.build).to include(
        "https://cran.r-project.org/src/contrib/A3_1.0.0.tar.gz",
        "https://cran.r-project.org/src/contrib/cultevo_1.0.2.tar.gz",
        "https://cran.r-project.org/src/contrib/cumprinc_0.1.tar.gz",
        "https://cran.r-project.org/src/contrib/cumSeg_1.3.tar.gz",
        "https://cran.r-project.org/src/contrib/cuperdec_1.1.0.tar.gz"
      )
    end
  end
end
