json.uid location.uid
json.name location.title
json.address location.address_line
json.locations location.locations do |child|
  json.partial! 'booking_location', location: child
end
