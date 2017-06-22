class AddOnlineEnabledToLocation < ActiveRecord::Migration[4.2]
  def change
    add_column :locations, :online_booking_enabled, :boolean, default: false
  end
end
