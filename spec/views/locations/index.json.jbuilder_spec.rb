require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'locations/index' do
  let(:location) do
    build(
      :location,
      uid: '25de9301-50b5-49ba-a5da-7f40a2fcfe29',
      title: 'Test location',
      accessibility_information: 'Lift is temporarily broken'
    )
  end

  it 'renders the locations as json' do
    @locations =  [location]

    render

    expect(JSON.parse(rendered)).to eq(
      'type' => 'FeatureCollection',
      'features' => [
        {
          'type' => 'Feature',
          'id' => '25de9301-50b5-49ba-a5da-7f40a2fcfe29',
          'geometry' => {
            'type' => 'Point',
            'coordinates' => [12.12, 45.45]
          },
          'properties' => {
            'title' => 'Test location',
            'address' => "#{location.address.address_line_1}\nTesting centre\nTest Avenue\nTest Vile\nTesty\nUB9 4LH",
            'booking_location_id' => '',
            'phone' => location.phone,
            'hours' => 'MON-FRI 9am-5pm',
            'twilio_number' => location.twilio_number,
            'online_booking_enabled' => false,
            'realtime' => false,
            'accessibility_information' => 'Lift is temporarily broken'
          }
        }
      ]
    )
  end
end
# rubocop:enable Metrics/BlockLength
