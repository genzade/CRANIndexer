# frozen_string_literal: true

class Package < ApplicationRecord
  validates :name, presence: true

  def download_url
    "#{Rails.application.config_for(:cran).fetch(:base_url)}#{name}_#{version}.tar.gz"
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[name]
  end
end
