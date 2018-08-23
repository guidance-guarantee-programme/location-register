module GoogleMapsApiHelper
  def google_maps_api_source_url
    api_key = ENV.fetch('GOOGLE_MAP_API_KEY')

    "https://maps.googleapis.com/maps/api/js?key=#{api_key}&region=GB&libraries=geometry"
  end
end
