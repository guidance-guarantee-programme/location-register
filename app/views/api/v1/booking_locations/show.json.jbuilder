json.partial! 'booking_location', location: @location

json.guiders @location.guiders do |guider|
  json.id guider.id
  json.name guider.name
  json.email guider.email
end

json.slots @location.slots do |slot|
  json.date slot.date
  json.start slot.start
  json.end slot.end
end
