class AddOnlineBookingWeekendsToLocations < ActiveRecord::Migration[5.1]
  def change
    add_column :locations, :online_booking_weekends, :boolean, null: false, default: false
  end
end
