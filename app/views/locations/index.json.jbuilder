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
  end
end
