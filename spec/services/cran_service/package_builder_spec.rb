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

  # ----

  # it "creates a package record from gzip link string", vcr: "cran/Ac3net_package_url" do
  #   package_url = "https://cran.r-project.org/src/contrib/Ac3net_1.2.2.tar.gz"
  #   package_builder = CranService::PackageBuilder.new(package_url)

  #   expect { package_builder.call }.to change(Package, :last)
  #     .from(nil)
  #     .to(
  #       an_object_having_attributes(
  #         name: "Ac3net",
  #         version: "1.2.2",
  #         required_r_version: "R (>= 3.3.0)",
  #         dependencies: ["R (>= 3.3.0)", "data.table"],
  #         date_publication_at: DateTime.parse("2018-02-26 22:08:20 UTC"),
  #         title: "Inferring Directional Conservative Causal Core Gene Networks",
  #         authors: ["Gokmen Altay"],
  #         maintainers: ["Gokmen Altay <altaylabs@gmail.com>"],
  #         license: "GPL (>= 3)"
  #       )
  #     )
  # end

  # context "when package already exists" do
  #   it "does not create a new package record", vcr: "cran/Ac3net_package_url" do
  #     create(
  #       :package,
  #       name: "Ac3net",
  #       version: "1.2.2",
  #       dependencies: ["R (>= 3.3.0)", "data.table"],
  #     )
  #     package_url = "https://cran.r-project.org/src/contrib/Ac3net_1.2.2.tar.gz"
  #     package_builder = CranService::PackageBuilder.new(package_url)

  #     package_builder.call
  #     expect { package_builder.call }.not_to change(Package, :count)
  #   end
  # end
end
