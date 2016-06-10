json.partial! 'booking_location', location: @location

json.slots @location.slots do |slot|
  json.date slot.date
  json.start slot.start
  json.end slot.end
end
