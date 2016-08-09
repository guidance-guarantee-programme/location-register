class RemovePhoneWhenBookingLocation < ActiveRecord::Migration
  def change
    execute %(
      UPDATE locations
      SET phone = ''
      WHERE (phone != '' OR phone IS NOT NULL) and booking_location_uid IS NOT NULL
    )

    execute %(
      UPDATE locations
      SET hours = ''
      WHERE (hours != '' OR hours IS NOT NULL) and booking_location_uid IS NOT NULL
    )
  end
end
