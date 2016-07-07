class AddOnlineBookingTwilioNumberToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :online_booking_twilio_number, :string, default: '', null: false
  end
end
