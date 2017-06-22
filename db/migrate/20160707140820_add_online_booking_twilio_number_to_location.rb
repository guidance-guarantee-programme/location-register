class AddOnlineBookingTwilioNumberToLocation < ActiveRecord::Migration[4.2]
  def change
    add_column :locations, :online_booking_twilio_number, :string, default: '', null: false
  end
end
