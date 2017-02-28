require 'rails_helper'

RSpec.describe Location do
  describe '.latest_for_twilio_number' do
    let(:user) { create(:user) }
    let(:location_1_ver_1) { create(:location) }
    let!(:location_1_ver_2) { CreateOrUpdateLocation.new(location: location_1_ver_1, user: user).update(params) }

    context 'when a location has has multiple twilio number' do
      let(:params) { { 'phone' => '+44999999999', 'twilio_number' => '+44999999111' } }

      it 'returns the most recent version for each twilio number' do
        expect(described_class.latest_for_twilio_number).to eq(
          location_1_ver_2.twilio_number => location_1_ver_2,
          location_1_ver_1.twilio_number => location_1_ver_1
        )
      end
    end

    context 'when a locations is edited without the twilio number changing' do
      let(:params) { { 'title' => 'New Name' } }

      it 'only returns the latest version of the location' do
        expect(described_class.latest_for_twilio_number).to eq(
          location_1_ver_2.twilio_number => location_1_ver_2
        )
      end
    end

    context 'when two locations have used the same twilio number' do
      let(:params) { { 'phone' => '+44999999999', 'twilio_number' => '+44999999111' } }
      let!(:location_2) { create(:location, twilio_number: location_1_ver_1.twilio_number) }

      it 'the newer location takes precedence over the old location' do
        expect(described_class.latest_for_twilio_number).to eq(
          location_2.twilio_number => location_2,
          location_1_ver_2.twilio_number => location_1_ver_2
        )
      end
    end

    context 'when a location has an online booking twilio number' do
      let(:params) { { 'online_booking_twilio_number' => '+44999999111' } }

      it 'returns a location for both twilio number and online twilio number' do
        expect(described_class.latest_for_twilio_number).to eq(
          location_1_ver_2.twilio_number => location_1_ver_2,
          location_1_ver_2.online_booking_twilio_number => location_1_ver_2
        )
      end
    end
  end

  describe '#guiders' do
    context 'for child locations' do
      it 'is invalid with associated guiders' do
        location = build(:location, booking_location_uid: 'deadbeef')
        location.guiders << build(:guider)

        expect(location).to_not be_valid
      end
    end

    context 'for booking locations' do
      it 'is valid with associated guiders' do
        location = build(:booking_location)
        location.guiders << build(:guider)

        expect(location).to be_valid
      end
    end
  end

  describe '#slots' do
    context 'for a non-booking location' do
      let(:location) { build(:location, booking_location_uid: 'deadbeef') }

      it 'returns the slots' do
        expect(location.slots).to_not be_empty
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

    context 'with multiple locations of differing version' do
      let(:uid) { booking_location.uid }

      before do
        booking_location.update_attribute(:state, 'old')
      end

      it 'returns only the current version' do
        expect(subject).to be_nil
      end
    end

    context 'with inactive locations' do
      let(:uid) { booking_location.uid }

      before do
        booking_location.update_attribute(:hidden, true)
      end

      it 'returns only active versions' do
        expect(subject).to be_nil
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

  it 'can create a new record with a phone number and no twilio number' do
    location = build(:location, twilio_number: nil, hidden: true)
    expect(location).to be_valid
  end

  describe 'editing the phone number' do
    let(:version_3) do
      build(:location, uid: '12345', version: 3, phone: '+44123456111', twilio_number: '+44987654321', state: 'old')
        .tap { |l| l.save!(validate: false) }
    end
    let(:version_4) do
      version_3
      build(:location, uid: '12345', version: 4, phone: version_4_phone, twilio_number: version_4_twilio, state: 'old')
        .tap { |l| l.save!(validate: false) }
    end
    let(:version_5) do
      version_4
      build(:location, uid: '12345', version: 5, phone: version_5_phone, twilio_number: version_5_twilio)
    end

    context 'phone number has changed' do
      let(:version_4_twilio) { '+44987654321' }
      let(:version_4_phone) { '+44123456789' }
      let(:version_5_phone) { '+44123456222' }

      context 'and the twilio number has changed' do
        let(:version_5_twilio) { '+44987654222' }

        it 'existing records are valid' do
          expect(version_4).to be_valid
        end

        it 'edits are valid' do
          expect(version_5).to be_valid
        end
      end

      context 'and the twilio number has not changed' do
        let(:version_5_twilio) { version_4_twilio }

        it 'existing records are valid' do
          expect(version_4).to be_valid
        end

        it 'edits are valid' do
          expect(version_5).to be_valid
        end
      end
    end
  end
end
