class ChangeLocationsOnlineBookingTwilioNumberNull < ActiveRecord::Migration
  def change
    change_column_null :locations, :online_booking_twilio_number, true, default: ''
  end
end
