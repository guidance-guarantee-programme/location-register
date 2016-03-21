require 'rails_helper'

RSpec.describe ToggleLocationVisibility do
  let!(:location) { FactoryGirl.create(:location) }
  subject { described_class.new(uid: location.uid) }

  describe '#toggle' do
    it 'creates a new location entry' do
      expect { subject.toggle }.to change { Location.count }.by(1)
    end

    it 'increments the version for the new location record' do
      expect(subject.toggle.version).to eq(location.version + 1)
    end

    it 'marks the old location state as "old"' do
      subject.toggle
      expect(location.reload.state).to eq('old')
    end

    it 'changes the hidden flag' do
      expect(subject.toggle.hidden).not_to eq(location.hidden)
    end
  end
end
