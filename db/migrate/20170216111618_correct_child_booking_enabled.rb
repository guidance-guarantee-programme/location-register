class CorrectChildBookingEnabled < ActiveRecord::Migration[5.0]
  def up
    booking_locations = Location.current.active.where(
      booking_location_uid: nil,
      online_booking_enabled: true
    )

    puts "Correcting #{booking_locations.count} booking locations"

    booking_locations.each do |booking_location|
      children = booking_location.locations.current.active

      children.update_all(online_booking_enabled: true)
    end
  end

  def down
    # noop
  end
end
