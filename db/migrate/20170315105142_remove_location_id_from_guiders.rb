class RemoveLocationIdFromGuiders < ActiveRecord::Migration[5.0]
  def change
    remove_column :guiders, :location_id
  end
end
