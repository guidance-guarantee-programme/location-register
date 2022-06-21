module GoogleMapsApiHelper
  def google_maps_api_source_url
    api_key   = ENV.fetch('GOOGLE_MAP_API_KEY')
    signature = ENV.fetch('GOOGLE_MAP_API_SIGNATURE')

    "https://maps.googleapis.com/maps/api/js?key=#{api_key}&region=GB&libraries=geometry&signature=#{signature}"
  end
end
