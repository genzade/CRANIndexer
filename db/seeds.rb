Adapter.r_packages.package_urls.sample(100).each do |package_url|
  puts "building package from: #{package_url}"

  package_builder = CranService::PackageBuilder.new(package_url)

  ActiveRecord::Base.transaction { package_builder.call }
end
