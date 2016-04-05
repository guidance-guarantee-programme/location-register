class RemoveLegacyCurieDbFields < ActiveRecord::Migration
  def up
    remove_column :locations, :address
    remove_column :locations, :booking_location
  end

  def down
    add_column :locations, :address, :string
    add_column :locations, :booking_location, :string

    Location.all.each do |location|
      location['address'] = "[address:#{Address.find(location.address_id).uid}]"
      location['booking_location'] = "[location:#{location.booking_location_uid}]" if location.booking_location_uid
      location.save!
    end
  end
end
