require 'rails_helper'

RSpec.describe 'locations/index' do
  it 'renders the locations as json' do
    assign(
      :locations,
      [FactoryGirl.build(:location, uid: '25de9301-50b5-49ba-a5da-7f40a2fcfe29', title: 'Test location')]
    )

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
            'address' => "Test flat 3\nTesting center\nTest Avenue\nTest Vile\nTesty\nTT11 35AA",
            'booking_location_id' => '',
            'phone' => '01111111111',
            'hours' => 'MON-FRI 9am-5pm'
          }
        }
      ]
    )
  end
end