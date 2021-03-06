json.type 'FeatureCollection'
json.features @locations do |location|
  json.type 'Feature'
  json.id location.uid
  json.geometry location.address.point
  json.properties do
    json.title location.title
    json.address location.address.to_a.join("\n")
    json.booking_location_id location.booking_location&.uid.to_s
    json.phone location.phone.to_s
    json.hours location.hours.to_s
    json.twilio_number location.twilio_number
    json.online_booking_enabled location.can_take_online_bookings?
    json.realtime location.realtime
    json.accessibility_information location.accessibility_information
  end
end
