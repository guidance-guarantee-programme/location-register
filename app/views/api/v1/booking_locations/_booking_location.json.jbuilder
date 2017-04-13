json.uid location.uid
json.name location.title
json.address location.address_line
json.online_booking_reply_to location.online_booking_reply_to
json.online_booking_twilio_number location.online_booking_twilio_number
json.hidden location.hidden

json.slots location.slots do |slot|
  json.date slot.date
  json.start slot.start
  json.end slot.end
end

json.locations location.locations.current do |child|
  json.partial! 'booking_location', location: child
end
