class AddBookingReplyToEmailToLocations < ActiveRecord::Migration[5.0]
  def change
    add_column :locations, :online_booking_reply_to, :string, null: false, default: ''
  end
end
