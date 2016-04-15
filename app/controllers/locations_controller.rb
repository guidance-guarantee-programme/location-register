class LocationsController < ApplicationController
  def index
    expires_in Rails.application.config.cache_max_age, public: true

    @locations = Location.current.includes(:address, :booking_location)

    unless params[:include_hidden_locations]
      @locations = @locations.where(hidden: false)
    end

    respond_to do |format|
      format.json
    end
  end
end
