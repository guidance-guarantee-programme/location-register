module Api
  module V1
    class BookingLocationsController < ActionController::Base
      def show
        @location = Location.booking_location_for(params[:uid])

        render json: @location
      end
    end
  end
end
