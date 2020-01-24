class AddAccessibilityInformationToLocations < ActiveRecord::Migration[5.2]
  def change
    add_column :locations, :accessibility_information, :string, null: false, default: ''
  end
end
