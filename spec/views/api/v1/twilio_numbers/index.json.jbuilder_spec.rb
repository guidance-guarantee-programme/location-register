require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe 'api/v1/twilio_numbers/index.json.jbuilder' do
  let(:booking_location) { create(:location) }
  let(:location) { create(:location, booking_location: booking_location) }

  before do
    assign :locations, booking_location.twilio_number => booking_location, location.twilio_number => location
    render
  end

  subject { JSON.parse(rendered)['twilio_numbers'] }

  it 'renders the particulars for a location without a booking location' do
    expect(subject[booking_location.twilio_number]).to eq(
      'uid' => booking_location.uid,
      'location' => booking_location.title,
      'location_postcode' => booking_location.address.postcode,
      'booking_location' => booking_location.title,
      'booking_location_postcode' => booking_location.address.postcode,
      'delivery_partner' => booking_location.organisation,
      'hours' => booking_location.hours
    )
  end

  it 'renders the particulars for a location with a booking location' do
    expect(subject[location.twilio_number]).to eq(
      'uid' => location.uid,
      'location' => location.title,
      'location_postcode' => location.address.postcode,
      'booking_location' => booking_location.title,
      'booking_location_postcode' => booking_location.address.postcode,
      'delivery_partner' => booking_location.organisation,
      'hours' => booking_location.hours
    )
  end
end
# rubocop:enable Metrics/BlockLength
