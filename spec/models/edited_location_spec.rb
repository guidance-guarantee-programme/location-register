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

  describe '#initialize' do
    it 'delegates to the newest location in the array' do
      result = subject.new([location_2, location_1])
      expect(result.__getobj__).to eq(location_2)
    end

    context 'when no previous location can be found' do
      it 'gets all the edited location fields for each location' do
        expect(EditedLocationField).to receive(:all).with(location_1, nil).and_call_original
        subject.new([location_1])
      end
    end

    context 'when a previous location can be found' do
      before do
        allow(Location).to receive(:find_by).with(uid: uid, version: 1).and_return(location_1)
      end

      it 'gets all the edited location fields for each location' do
        expect(EditedLocationField).to receive(:all).with(location_2, location_1).and_call_original
        subject.new([location_2])
      end
    end
  end
end
