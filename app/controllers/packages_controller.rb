# frozen_string_literal: true

class PackagesController < ApplicationController
  # before_action :set_package, only: %i[show edit update destroy]

  # GET /packages
  def index
    @packages = Package.all
  end

  # GET /packages/1
  def show; end

  # private

  # # Use callbacks to share common setup or constraints between actions.
  # def set_package
  #   @package = Package.find(params[:id])
  # end

  # # Only allow a list of trusted parameters through.
  # def package_params
  #   params.require(:package).permit(:name, :version, :required_r_version, :dependencies, :date_publication_at,
  #                                   :title, :authors, :maintainers, :license)
  # end
end
