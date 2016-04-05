class AddActiveRecordLookupsToReplaceCurie < ActiveRecord::Migration
  def up
    add_reference :locations, :address
    add_column :locations, :booking_location_uid, :string
    add_index :locations, :booking_location_uid

    Location.all.each do |location|
      address_uid = extract_uid(location['address'])
      booking_location_uid = extract_uid(location['booking_location'])

      location.update_attributes!(
        address_id: Address.find_by!(uid: address_uid).id,
        booking_location_uid: booking_location_uid
      )
    end
  end

  def down
    remove_column :locations, :address_id
    remove_column :locations, :booking_location_uid
  end

  private

  def extract_uid(field)
    return nil if field.nil?
    field.match(/^\[[^:]*:(.*)\]$/)[1]
  end
end
