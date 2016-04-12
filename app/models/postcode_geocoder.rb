require 'geocoder'

class PostcodeGeocoder
  def initialize(postcode)
    @geocodes = Geocoder.search(postcode)
  end

  def valid?
    if @geocodes.empty?
      false
    elsif @geocodes.count == 1
      @geocodes.first.data['address_components'].any? { |a| a['types'] == ['postal_code'] }
    else
      # add functionality to handle multiple results
      false
    end
  end

  def coordinates
    geocode = @geocodes.first
    [geocode.longitude, geocode.latitude]
  end
end
