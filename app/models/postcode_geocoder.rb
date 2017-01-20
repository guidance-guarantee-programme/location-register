require 'geocoder'

class PostcodeGeocoder
  def initialize(postcode)
    @geocodes = filter_postal_code_result(Geocoder.search(postcode))
  end

  def valid?
    @geocodes.count == 1
  end

  def coordinates
    geocode = @geocodes.first
    [geocode.longitude, geocode.latitude]
  end

  def filter_postal_code_result(geocodes)
    geocodes.select do |geocode|
      geocode.data['address_components'].any? { |a| a['types'] == ['postal_code'] }
    end
  end
end
