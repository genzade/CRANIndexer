# frozen_string_literal: true

require "rails_helper"

RSpec.describe PackagesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/packages").to route_to("packages#index")
    end

    it "routes to #show" do
      expect(get: "/packages/1").to route_to("packages#show", id: "1")
    end
  end
end
