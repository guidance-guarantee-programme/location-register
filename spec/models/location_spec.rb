require 'rails_helper'

RSpec.describe Location do
  describe '#slots' do
    context 'for a non-booking location' do
      let(:location) { build(:location, booking_location_uid: 'deadbeef') }

      it 'returns an empty array' do
        expect(location.slots).to eq([])
      end
    end

    context 'for a booking location' do
      let(:location) { build(:location) }

      it 'returns slots' do
        travel_to '2016-06-07 10:00:00' do
          expect(location.slots).to_not be_empty
        end
      end
    end
  end

  describe '.booking_location_for' do
    let(:booking_location) { create(:booking_location) }

    subject { described_class.booking_location_for(uid) }

    context 'with a booking location UID' do
      let(:uid) { booking_location.uid }

      it 'returns the booking location' do
        expect(subject).to eq(booking_location)
      end
    end

    context 'with a child location UID' do
      let(:uid) { booking_location.locations.first.uid }

      it 'returns the parent booking location' do
        expect(subject).to eq(booking_location)
      end
    end
  end

  describe '.externally_visible' do
    let!(:active_location) { create(:location, uid: '25de9301-50b5-49ba-a5da-7f40a2fcfe29') }
    let!(:hidden_location) { create(:location, uid: '25de9301-50b5-49ba-a5da-7f40a2fcfe29', hidden: true) }

    it 'includes hidden locations when include_hidden_locations is true' do
      locations = Location.externally_visible(include_hidden_locations: true)
      expect(locations).to match_array([active_location, hidden_location])
    end

    it 'excludes hidden locations when include_hidden_locations is false' do
      locations = Location.externally_visible(include_hidden_locations: false)
      expect(locations).to match_array([active_location])
    end
  end
end
