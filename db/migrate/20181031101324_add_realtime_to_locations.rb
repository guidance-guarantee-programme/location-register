class AddRealtimeToLocations < ActiveRecord::Migration[5.1]
  def change
    add_column :locations, :realtime, :boolean, null: false, default: false
  end
end
