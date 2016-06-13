module Api
  module V1
    class BookingLocationsController < ActionController::Base
      include GDS::SSO::ControllerMethods

      before_action :require_signin_permission!

      def show
        @location = Location.booking_location_for(params[:uid])

        head :not_found unless @location
      end
    end
  end
end
