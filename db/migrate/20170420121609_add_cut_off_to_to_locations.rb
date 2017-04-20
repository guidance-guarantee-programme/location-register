class AddCutOffToToLocations < ActiveRecord::Migration[5.0]
  def change
    add_column :locations, :cut_off_to, :date, null: true
  end
end
