class RemoveOldLocations < ActiveRecord::Migration[5.0]
  def change
    Location.where(state: 'old').destroy_all
  end
end
