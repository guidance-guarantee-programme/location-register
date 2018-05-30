require 'rails_helper'

RSpec.describe 'api/v1/booking_locations/show.json.jbuilder' do
  let(:booking_location) { create(:booking_location) }

  before do
    assign :location, booking_location

    travel_to '2016-06-05 10:00:00' do
      render
    end
  end

  subject { JSON.parse(rendered) }

  it 'renders the booking location particulars' do
    expect(subject).to include(
      'uid' => booking_location.uid,
      'name' => booking_location.title,
      'address' => booking_location.address_line,
      'online_booking_twilio_number' => booking_location.online_booking_twilio_number,
      'online_booking_reply_to' => 'dave@example.com',
      'online_booking_weekends' => true,
      'hidden' => booking_location.hidden
    )

    expect(subject['locations'].first).to include(
      'uid' => booking_location.locations.first.uid,
      'name' => booking_location.locations.first.title,
      'address' => booking_location.locations.first.address_line,
      'online_booking_twilio_number' => booking_location.online_booking_twilio_number,
      'online_booking_reply_to' => 'dave@example.com',
      'online_booking_weekends' => true,
      'hidden' => booking_location.locations.first.hidden,
      'locations' => []
    )

    expect(subject['guiders'].first).to eq(
      'id' => booking_location.guiders.first.id,
      'name' => 'Rick Sanchez',
      'email' => 'rick@example.com'
    )
  end
end
