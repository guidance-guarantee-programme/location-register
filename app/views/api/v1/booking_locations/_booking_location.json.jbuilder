json.uid location.uid
json.name location.title
json.address location.address_line
json.online_booking_twilio_number location.online_booking_twilio_number
json.locations location.locations.active.current do |child|
  json.partial! 'booking_location', location: child
end
