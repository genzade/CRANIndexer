# frozen_string_literal: true

require "rails_helper"

RSpec.describe CranService::AttributesBuilder do
  context "when the dcf_hash is invalid" do
    it "returns nil" do
      dcf_hash = {}
      attributes_builder = CranService::AttributesBuilder.new(dcf_hash)

      expect { attributes_builder.call }.to raise_error(
        CranService::Errors::InvalidDcfHashError,
        "Invalid dcf hash: `#{dcf_hash}`"
      )
    end

    context "when the dcf_hash is wrong type" do
      it "raises an error" do
        dcf_hash = "wrong type"
        attributes_builder = CranService::AttributesBuilder.new(dcf_hash)

        expect { attributes_builder.call }.to raise_error(
          CranService::Errors::InvalidDcfHashError,
          "Invalid dcf hash: `#{dcf_hash}`"
        )
      end
    end
  end

  context "when the dcf_hash is valid" do
    it "builds the attributes from passed in hash" do
      dcf_hash = {
        "Package" => "A3",
        "Type" => "Package",
        "Title" => "Accurate, Adaptable, and Accessible Error Metrics for Predictive\nModels",
        "Version" => "1.0.0",
        "Date" => "2015-08-15",
        "Author" => "Scott Fortmann-Roe",
        "Maintainer" => "Scott Fortmann-Roe <scottfr@berkeley.edu>",
        "Description" => "Supplies tools for tabulating and analyzing the results of predictive models.",
        "License" => "GPL (>= 2)",
        "Depends" => "R (>= 2.15.0), xtable, pbapply",
        "Suggests" => "randomForest, e1071",
        "NeedsCompilation" => "no",
        "Packaged" => "2015-08-16 14:17:33 UTC; scott",
        "Repository" => "CRAN",
        "Date/Publication" => "2015-08-16 23:05:52"
      }

      attributes_builder = CranService::AttributesBuilder.new(dcf_hash)

      expect(attributes_builder.call).to eq(
        name: "A3",
        version: "1.0.0",
        required_r_version: "R (>= 2.15.0)",
        dependencies: ["R (>= 2.15.0)", "xtable", "pbapply"],
        date_publication_at: DateTime.parse("2015-08-16 23:05:52"),
        title: "Accurate, Adaptable, and Accessible Error Metrics for Predictive Models",
        authors: ["Scott Fortmann-Roe"],
        maintainers: ["Scott Fortmann-Roe <scottfr@berkeley.edu>"],
        license: "GPL (>= 2)"
      )
    end

    context "when the dcf_hash is missing `Depends` key" do
      it "builds the attributes from passed in hash" do
        dcf_hash = {
          "Package" => "cultevo",
          "Title" => "Tools, Measures and Statistical Tests for Cultural Evolution",
          "Version" => "1.0.2",
          "Date" => "2018-04-24",
          "Authors@R" => "person(\"Kevin Stadler\", role=c(\"aut\", \"cre\"), email=\"a00425926@unet.univie.ac.at\")",
          "URL" => "https://kevinstadler.github.io/cultevo/",
          "BugReports" => "https://github.com/kevinstadler/cultevo/issues",
          "Encoding" => "UTF-8",
          "License" => "MIT + file LICENSE",
          "Imports" => "combinat, grDevices, graphics, Hmisc, pspearman, stats,\nstringi, utils",
          "Suggests" => "memoise, knitr, rmarkdown",
          "RoxygenNote" => "6.0.1",
          "VignetteBuilder" => "knitr",
          "NeedsCompilation" => "no",
          "Packaged" => "2018-04-24 09:50:38 UTC; kevin",
          "Author" => "Kevin Stadler [aut, cre]",
          "Maintainer" => "Kevin Stadler <a00425926@unet.univie.ac.at>",
          "Repository" => "CRAN",
          "Date/Publication" => "2018-04-24 10:28:19 UTC"
        }

        attributes_builder = CranService::AttributesBuilder.new(dcf_hash)

        expect(attributes_builder.call).to eq(
          name: "cultevo",
          version: "1.0.2",
          required_r_version: nil,
          dependencies: nil,
          date_publication_at: DateTime.parse("2018-04-24 10:28:19 UTC"),
          title: "Tools, Measures and Statistical Tests for Cultural Evolution",
          authors: ["Kevin Stadler"],
          maintainers: ["Kevin Stadler <a00425926@unet.univie.ac.at>"],
          license: "MIT + file LICENSE"
        )
      end
    end

    context "when the maintainer is not formatted correctly" do
      it "builds the attributes from passed in hash" do
        dcf_hash = {
          "Package" => "cultevo",
          "Version" => "1.0.2",
          "Title" => "Tools, Measures and Statistical Tests for Cultural Evolution",
          "Maintainer" => "James A. Fellows Yates <jfy133@gmail.com>",
          "Date" => "2018-04-24",
          "Date/Publication" => "2018-04-24 10:28:19 UTC"
        }

        attributes_builder = CranService::AttributesBuilder.new(dcf_hash)

        expect(attributes_builder.call).to eq(
          name: "cultevo",
          version: "1.0.2",
          title: "Tools, Measures and Statistical Tests for Cultural Evolution",
          required_r_version: nil,
          dependencies: nil,
          date_publication_at: DateTime.parse("2018-04-24 10:28:19 UTC"),
          authors: [],
          maintainers: ["James A. Fellows Yates <jfy133@gmail.com>"],
          license: nil
        )
      end
    end

    context "when the author has more than 2 names" do
      it "builds the attributes from passed in hash" do
        dcf_hash = {
          "Package" => "cultevo",
          "Title" => "Tools, Measures and Statistical Tests for Cultural Evolution",
          "Version" => "1.0.2",
          "Date" => "2018-04-24",
          "Authors@R" => "person(\"Kevin Stadler\", role=c(\"aut\", \"cre\"), email=\"a00425926@unet.univie.ac.at\")",
          "URL" => "https://kevinstadler.github.io/cultevo/",
          "BugReports" => "https://github.com/kevinstadler/cultevo/issues",
          "Encoding" => "UTF-8",
          "License" => "MIT + file LICENSE",
          "Imports" => "combinat, grDevices, graphics, Hmisc, pspearman, stats,\nstringi, utils",
          "Suggests" => "memoise, knitr, rmarkdown",
          "RoxygenNote" => "6.0.1",
          "VignetteBuilder" => "knitr",
          "NeedsCompilation" => "no",
          "Packaged" => "2018-04-24 09:50:38 UTC; kevin",
          "Author" => "James A. Fellows Yates",
          "Maintainer" => "Kevin Stadler <a00425926@unet.univie.ac.at>",
          "Repository" => "CRAN",
          "Date/Publication" => "2018-04-24 10:28:19 UTC"
        }

        attributes_builder = CranService::AttributesBuilder.new(dcf_hash)

        expect(attributes_builder.call).to eq(
          name: "cultevo",
          version: "1.0.2",
          authors: ["James A. Fellows Yates"],
          date_publication_at: DateTime.parse("2018-04-24 10:28:19 UTC"),
          dependencies: nil,
          license: "MIT + file LICENSE",
          maintainers: ["Kevin Stadler <a00425926@unet.univie.ac.at>"],
          required_r_version: nil,
          title: "Tools, Measures and Statistical Tests for Cultural Evolution"
        )
      end
    end
  end
end
