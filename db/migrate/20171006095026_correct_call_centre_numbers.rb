class CorrectCallCentreNumbers < ActiveRecord::Migration[5.1]
  def up
    # All locations in CITA and NICAB
    locations = Location.current.active.where(organisation: %w(cita nicab))
    locations.update_all(twilio_number: '+448001383944')

    # Update parent booking hours to reflect
    locations
      .where(booking_location_uid: '')
      .update_all(hours: 'Monday to Friday, 8am to 8pm')

    # Booking locations with online booking
    parents = locations
      .where(online_booking_enabled: true, booking_location_uid: '')
      .where.not(online_booking_twilio_number: '')

    parents.find_each do |parent|
      parent.update_attribute(:online_booking_twilio_number, parent.phone)
    end

    # Child locations with online booking and overridden numbers
    overrides = locations
      .where(online_booking_enabled: true)
      .where.not(booking_location_uid: '', online_booking_twilio_number: '')

    overrides.find_each do |child|
      child.update_attribute(:online_booking_twilio_number, child.phone)
    end
  end

  def down
    # noop
  end
end
