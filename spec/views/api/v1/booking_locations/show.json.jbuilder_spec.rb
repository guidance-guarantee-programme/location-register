require 'rails_helper'

RSpec.describe 'api/v1/booking_locations/show.json.jbuilder' do
  let(:booking_location) { create(:booking_location) }

  before do
    assign :location, booking_location
    render
  end

  it 'renders the booking location particulars' do
    expect(JSON.parse(rendered)).to include(
      'uid' => booking_location.uid,
      'name' => booking_location.title,
      'address' => booking_location.address_line,
      'locations' => [
        {
          'uid' => booking_location.locations.first.uid,
          'name' => booking_location.locations.first.title,
          'address' => booking_location.locations.first.address_line,
          'locations' => []
        },
        {
          'uid' => booking_location.locations.second.uid,
          'name' => booking_location.locations.second.title,
          'address' => booking_location.locations.second.address_line,
          'locations' => []
        }
      ]
    )
  end
end
