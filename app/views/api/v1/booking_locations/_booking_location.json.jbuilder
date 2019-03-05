json.uid location.uid
json.name location.title
json.address location.address_line
json.online_booking_reply_to location.online_booking_reply_to
json.online_booking_twilio_number location.canonical_online_booking_twilio_number
json.online_booking_weekends location.online_booking_weekends
json.hidden location.hidden
json.realtime location.realtime
json.organisation location.organisation

json.locations location.locations.current do |child|
  json.partial! 'booking_location', location: child
end
