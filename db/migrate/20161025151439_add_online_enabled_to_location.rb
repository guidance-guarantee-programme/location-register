class AddOnlineEnabledToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :online_booking_enabled, :boolean, default: false
  end
end
