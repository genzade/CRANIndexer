# frozen_string_literal: true

require "rails_helper"

# loads all the rake tasks
Rails.application.load_tasks

RSpec.describe Tasks::Cran::BuildRPackages, type: :task do
  def rake_task
    Rake::Task["cran:build_r_packages:run"]
  end

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
      .once

    [
      "A3_1.0.0.tar.gz",
      "cultevo_1.0.2.tar.gz",
      "cumprinc_0.1.tar.gz",
      "cumSeg_1.3.tar.gz",
      "cuperdec_1.1.0.tar.gz"
    ].each do |package|
      allow(URI).to receive(:parse)
        .with("#{base_url}#{package}")
        .and_return(
          double(
            open: file_fixture("cran/zips/#{package}").open
          )
        )
    end
  end

  after { rake_task.reenable }

  it "creates the R packages" do
    expect { rake_task.invoke }.to change(Package, :all)
      .from([])
      .to(
        a_collection_including(
          an_object_having_attributes(
            name: "A3",
            version: "1.0.0",
            authors: ["Scott Fortmann-Roe"],
            date_publication_at: DateTime.parse("2015-08-16 23:05:52"),
            dependencies: ["R (>= 2.15.0)", "xtable", "pbapply"],
            license: "GPL (>= 2)",
            maintainers: ["Scott Fortmann-Roe <scottfr@berkeley.edu>"],
            required_r_version: "R (>= 2.15.0)",
            title: "Accurate, Adaptable, and Accessible Error Metrics for Predictive Models"
          ),
          an_object_having_attributes(
            name: "cultevo",
            version: "1.0.2",
            authors: ["Kevin Stadler [aut, cre]"],
            date_publication_at: DateTime.parse("2018-04-24 10:28:19 UTC"),
            dependencies: nil,
            license: "MIT + file LICENSE",
            maintainers: ["Kevin Stadler <a00425926@unet.univie.ac.at>"],
            required_r_version: nil,
            title: "Tools, Measures and Statistical Tests for Cultural Evolution"
          ),
          an_object_having_attributes(
            name: "cumprinc",
            version: "0.1",
            authors: ["Jason Richardson [aut, cre] (<https://orcid.org/0000-0001-8166-7306>)"],
            date_publication_at: DateTime.parse("2022-11-30 11:20:08 UTC"),
            dependencies: nil,
            license: "GPL (>= 2)",
            maintainers: ["Jason Richardson <jcrichardson617@gmail.com>"],
            required_r_version: nil,
            title: "Functions Centered Around Microsoft Excel Cumprinc Function"
          ),
          an_object_having_attributes(
            name: "cumSeg",
            version: "1.3",
            authors: ["Vito M.R. Muggeo"],
            date_publication_at: DateTime.parse("2020-07-17 09:10:02 UTC"),
            dependencies: ["lars"],
            license: "GPL",
            maintainers: ["Vito M.R. Muggeo <vito.muggeo@unipa.it>"],
            required_r_version: nil,
            title: "Change Point Detection in Genomic Sequences"
          ),
          an_object_having_attributes(
            name: "cuperdec",
            version: "1.1.0",
            authors: ["James A. Fellows Yates [aut, cre]"],
            date_publication_at: DateTime.parse("2021-09-12 21:40:10 UTC"),
            dependencies: ["R (>= 3.5.0)"],
            license: "MIT + file LICENSE",
            maintainers: ["James A. Fellows Yates <jfy133@gmail.com>"],
            required_r_version: "R (>= 3.5.0)",
            title: "Cumulative Percent Decay Curve Generator"
          )
        )
      )
  end
end
