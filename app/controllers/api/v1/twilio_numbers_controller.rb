module Api
  module V1
    class TwilioNumbersController < ActionController::Base
      include GDS::SSO::ControllerMethods

      before_action :require_signin_permission!

      def index
        @locations = Location.latest_for_twilio_number
      end
    end
  end
end
