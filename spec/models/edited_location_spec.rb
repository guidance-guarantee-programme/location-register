require 'rails_helper'

RSpec.describe EditedLocation do
  subject { described_class }
  let(:uid) { SecureRandom.uuid }
  let(:location_1) { build(:location, uid: uid, created_at: 1.hour.ago, version: 1) }
  let(:location_2) { build(:location, uid: uid, created_at: 1.minute.ago, version: 2) }
  let(:location_3) { build(:location, created_at: 5.minutes.ago) }

  describe '.all' do
    it 'return an array of Edit Location instances' do
      result = subject.all([location_1])
      expect(result).to be_a(Array)
      expect(result[0]).to be_a(described_class)
    end

    it 'groups locations with the same uid into a single entry' do
      result = subject.all([location_1, location_2])
      expect(result.size).to eq(1)
    end

    it 'does not group locations  with different uids' do
      result = subject.all([location_1, location_3])
      expect(result.size).to eq(2)
    end
  end

  %i[uid title booking_location].each do |field|
    describe "##{field}" do
      it 'delegates to the array element with the highest version number' do
        result = subject.new([location_2, location_1])
        expect(result.public_send(field)).to eq(location_2.public_send(field))

        result = subject.new([location_1, location_2])
        expect(result.public_send(field)).to eq(location_2.public_send(field))
      end
    end
  end

  describe '.edits' do
    subject { described_class.new(versions) }

    let(:new_location) { location(version: 2) }
    let(:old_location) { location(version: 1) }
    let(:versions) { [new_location, old_location] }

    let(:edits) { subject.edits[new_location.created_at] }
    let(:latest_edit) { edits.last }

    it 'returns edits grouped by when there where edited' do
      new_location.title = 'Beta'
      old_location.title = 'Alpha'

      expect(subject.edits.keys).to match_array([new_location.created_at, old_location.created_at])
    end

    it 'returns edit records for each field edited' do
      new_location.title = 'Beta'

      expect(edits.count).to eq(1)
    end

    context 'when a record was edited' do
      before do
        new_location.title = 'Beta'
        old_location.title = 'Alpha'
      end

      it 'knows which field was edited' do
        expect(latest_edit.field).to eq('title')
      end

      it 'knows the old value of the field' do
        expect(latest_edit.old_value).to eq('Alpha')
      end

      it 'knows the new value of the field' do
        expect(latest_edit.new_value).to eq('Beta')
      end

      it 'knows the time the edit was created at' do
        expect(latest_edit.created_at).to eq(new_location.created_at)
      end

      it 'knows who edited the the field' do
        expect(latest_edit.editor).to eq(new_location.editor)
      end
    end

    context 'when new location has been created - no old location' do
      let(:versions) { [new_location] }
      before { new_location.title = 'Alpha' }

      it 'set the old value to nil' do
        expect(latest_edit.old_value).to be_nil
      end
    end

    context 'when the edited field is ignored' do
      before do
        new_location.created_at = 1.day.ago
        old_location.created_at = 2.days.ago
      end

      it 'ignores the edit' do
        expect(subject.edits).to be_empty
      end
    end

    context 'use subclass based on the field being edited' do
      it 'for the hidden field' do
        old_location.hidden = true

        expect(latest_edit).to be_a(EditedField::VisibilityField)
      end

      it 'for the address field' do
        old_location.address = build(:address)
        expect(latest_edit).to be_a(EditedField::AddressField)
      end

      it 'for the booking_location field' do
        old_location.booking_location = build(:location)
        expect(latest_edit).to be_a(EditedField::BookingLocationField)
      end
    end

    def location(attributes = {})
      base_attributes = {
        created_at: Time.zone.now,
        editor: User.new(name: 'Primary editor'),
        hidden: nil
      }
      Location.new(base_attributes.merge(attributes))
    end
  end
end
