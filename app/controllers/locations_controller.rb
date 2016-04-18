class LocationsController < ApplicationController
  def index
    expires_in Rails.application.config.cache_max_age, public: true

    @locations = Location.externally_visible(include_hidden_locations: params[:include_hidden_locations])

    respond_to do |format|
      format.json
    end
  end
end
