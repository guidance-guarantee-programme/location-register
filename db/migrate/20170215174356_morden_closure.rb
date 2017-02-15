class MordenClosure < ActiveRecord::Migration[5.0]
  def up
    morden  = Location.current.active.find_by(uid: '253a5060-9fc7-4936-8ab2-805b8ac0e781')
    mitcham = Location.current.active.find_by(uid: '848a0ab6-d59f-4f4c-93fb-acc0360af89d')

    return unless morden && mitcham

    # switch Morden's children to Mitcham
    morden.locations.active.current.update_all(booking_location_uid: mitcham.uid)

    # switch Morden's guiders to Mitcham
    morden.guiders.update_all(location_id: mitcham.id)

    # promote Mitcham as the new booking location
    mitcham.update!(
      booking_location_uid: nil,
      online_booking_enabled: true,
      phone: morden.phone,
      hours: morden.hours
    )

    # demote Morden and make Mitcham its booking location
    morden.update!(
      online_booking_enabled: false,
      booking_location_uid: mitcham.uid,
      phone: nil,
      hours: nil
    )
  end

  def down
    # noop
  end
end
