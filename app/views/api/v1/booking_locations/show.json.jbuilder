json.uid @location.uid
json.name @location.title
json.address @location.address_line
json.online_booking_reply_to @location.online_booking_reply_to
json.online_booking_twilio_number @location.canonical_online_booking_twilio_number
json.online_booking_weekends @location.online_booking_weekends
json.hidden @location.hidden
json.realtime @location.realtime
json.organisation @location.organisation

json.locations @location.locations.current do |child|
  json.uid child.uid
  json.name child.title
  json.address child.address_line
  json.online_booking_reply_to child.online_booking_reply_to
  json.online_booking_twilio_number child.canonical_online_booking_twilio_number
  json.online_booking_weekends child.online_booking_weekends
  json.hidden child.hidden
  json.realtime child.realtime
  json.organisation child.organisation
  json.locations []
end

json.guiders @location.guiders do |guider|
  json.id guider.id
  json.name guider.name
  json.email guider.email
end
