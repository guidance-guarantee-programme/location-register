json.partial! 'booking_location', location: @location

json.guiders @location.guiders do |guider|
  json.id guider.id
  json.name guider.name
  json.email guider.email
end
