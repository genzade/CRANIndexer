# frozen_string_literal: true

FactoryBot.define do
  factory(:package) do
    name { Faker::Name.name }
    version { "1.0.0" }
  end
end
