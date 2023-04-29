# frozen_string_literal: true

module Adapter
  class << self
    def respond_to_missing?(method, include_private = false)
      Rails.application.config.respond_to?("#{method}_adapter") || super
    end

    def method_missing(method, *args, &)
      Rails.application.config.send "#{method}_adapter"
    rescue NameError
      super
    end
  end
end
