class LocationsController < ApplicationController
  def index
    expires_in Rails.application.config.cache_max_age, public: true

    @locations = Location.includes(:address, :booking_location).where(state: 'current', hidden: false)

    respond_to do |format|
      format.json
    end
  end
end
