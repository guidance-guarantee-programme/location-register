json.twilio_numbers  do
  @locations.each do |location|
    json.set!(location.twilio_number) do
      json.uid location.uid

      json.delivery_partner location.organisation

      json.location location.title
      json.location_postcode location.address.postcode

      json.booking_location location.canonical_location.title
      json.booking_location_postcode location.canonical_location.address.postcode

      json.hours location.canonical_location.hours
    end
  end
end
