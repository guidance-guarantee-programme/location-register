class MoveAddressIntoLocation < ActiveRecord::Migration[5.0]
  class Location < ApplicationRecord
    belongs_to :address
  end

  class Address < ApplicationRecord
  end

  def change
    add_column :locations, :point, :jsonb
    add_column :locations, :address_line_1, :string
    add_column :locations, :address_line_2, :string
    add_column :locations, :address_line_3, :string
    add_column :locations, :town, :string
    add_column :locations, :county, :string
    add_column :locations, :postcode, :string

    Location.all.each do |location|
      address = location.address
      new_attributes = {
        point: address.point.to_json,
        address_line_1: address.address_line_1,
        address_line_2: address.address_line_2,
        address_line_3: address.address_line_3,
        town: address.town,
        county: address.county,
        postcode: address.postcode
      }
      location.update_columns(new_attributes)
    end

    drop_table :addresses
  end
end
