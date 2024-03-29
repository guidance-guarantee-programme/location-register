require 'rails_helper'

RSpec.describe GoogleMapsApiHelper, '#google_maps_api_source_url' do
  it 'returns a URL which includes the API key' do
    allow(ENV).to receive(:fetch).with('GOOGLE_MAP_API_KEY').and_return('fake-key')
    allow(ENV).to receive(:fetch).with('GOOGLE_MAP_API_SIGNATURE').and_return('fake-signature')

    expect(google_maps_api_source_url).to eq(
      'https://maps.googleapis.com/maps/api/js?key=fake-key&region=GB&libraries=geometry&signature=fake-signature'
    )
  end
end
