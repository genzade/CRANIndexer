# frozen_string_literal: true

require "rails_helper"

RSpec.describe CranService::PackageBuilder do
  it "creates a package record from gzip link string", vcr: "cran/A3_old_version_package_url" do
    package_url = "https://cran.r-project.org/src/contrib/Archive/A3/A3_0.9.2.tar.gz"
    package_builder = CranService::PackageBuilder.new(package_url)

    expect { package_builder.call }.to change(Package, :last)
      .from(nil)
      .to(
        an_object_having_attributes(
          name: "A3",
          version: "0.9.2",
          required_r_version: "R (>= 2.15.0)",
          dependencies: ["R (>= 2.15.0)", "xtable", "pbapply"],
          date_publication_at: DateTime.parse("2013-03-26 19:58:40"),
          title: "A3: Accurate, Adaptable, and Accessible Error Metrics for Predictive Models",
          authors: ["Scott Fortmann-Roe"],
          maintainers: ["Scott Fortmann-Roe <scottfr@berkeley.edu>"],
          license: "GPL (>= 2)"
        )
      )
  end

  context "when package already exists" do
    it "does not create a new package record", vcr: "cran/A3_old_version_package_url" do
      create(
        :package,
        name: "A3",
        version: "0.9.2"
      )
      package_url = "https://cran.r-project.org/src/contrib/Archive/A3/A3_0.9.2.tar.gz"
      package_builder = CranService::PackageBuilder.new(package_url)

      expect { package_builder.call }.not_to change(Package, :last)
    end

    context "when a newer version of the package" do
      it "creates a newer package version record", vcr: "cran/A3_new_version_package_url" do
        create(
          :package,
          name: "A3",
          version: "0.9.2"
        )
        package_url = "https://cran.r-project.org/src/contrib/A3_1.0.0.tar.gz"
        package_builder = CranService::PackageBuilder.new(package_url)

        expect { package_builder.call }.to change(Package, :all)
          .from(
            a_collection_including(
              an_object_having_attributes(name: "A3", version: "0.9.2")
            )
          )
          .to(
            a_collection_including(
              an_object_having_attributes(name: "A3", version: "0.9.2"),
              an_object_having_attributes(name: "A3", version: "1.0.0")
            )
          )
      end
    end
  end

  context "when data is not `UTF-8` encoded" do
    it "creates a package record from gzip link string", vcr: "cran/BACprior_package_url" do
      package_url = "https://cran.r-project.org/src/contrib/BACprior_2.1.tar.gz"
      package_builder = CranService::PackageBuilder.new(package_url)

      expect { package_builder.call }.to change(Package, :last)
        .from(nil)
        .to(
          an_object_having_attributes(
            name: "BACprior",
            version: "2.1",
            required_r_version: nil,
            dependencies: %w[mvtnorm leaps boot],
            date_publication_at: DateTime.parse("2022-05-02 19:12:02 UTC"),
            title: "Choice of Omega in the BAC Algorithm",
            authors: ["Denis Talbot", "Geneviève Lefebvre", "Juli Atherton"],
            maintainers: ["Denis Talbot <denis.talbot@fmed.ulaval.ca>"],
            license: "GPL (>= 2)"
          )
        )
    end
  end

  context "when" do
    it "creates a package record from gzip link string", vcr: "cran/breakaway_package_url" do
      package_url = "https://cran.r-project.org/src/contrib/breakaway_4.8.4.tar.gz"
      package_builder = CranService::PackageBuilder.new(package_url)

      expect { package_builder.call }.to change(Package, :last)
        .from(nil)
        .to(
          an_object_having_attributes(
            name: "breakaway",
            version: "4.8.4",
            authors: ["Amy D Willis", "Bryan D Martin", "Pauline Trinh", "Sarah Teichman",
                      "David Clausen", "Kathryn Barger", "John Bunge"],
            date_publication_at: DateTime.parse("2022-11-22 09:10:27 UTC"),
            dependencies: ["R (>= 3.5.0)"],
            license: "GPL-2",
            maintainers: ["Amy D Willis <adwillis@uw.edu>"],
            required_r_version: "R (>= 3.5.0)",
            title: "Species Richness Estimation and Modeling"
          )
        )
    end
  end
end
