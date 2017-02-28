class AddCutOffFromToLocations < ActiveRecord::Migration[5.0]
  def change
    add_column :locations, :cut_off_from, :date, null: true
  end
end
