require 'rails_helper'

RSpec.describe 'locations/index' do
  let(:location) { build(:location, uid: '25de9301-50b5-49ba-a5da-7f40a2fcfe29', title: 'Test location') }

  it 'renders the locations as json' do
    assign(:locations, [location])

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
            'twilio_number' => location.twilio_number
          }
        }
      ]
    )
  end
end
