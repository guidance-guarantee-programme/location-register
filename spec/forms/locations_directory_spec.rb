require 'rails_helper'

# rubocop:disable Metrics/BlockLength
RSpec.describe LocationsDirectory do
  let(:user) { instance_double('User', pensionwise_admin?: true) }

  describe 'display_active' do
    it 'default to true when no value is set' do
      expect(described_class.new(user, {}).display_active).to be_truthy
    end

    it 'false when value is an empty string' do
      expect(described_class.new(user, locations_directory: { display_active: '' }).display_active).to be_falsey
    end

    it 'false when value is a`0`' do
      expect(described_class.new(user, locations_directory: { display_active: '0' }).display_active).to be_falsey
    end

    it 'false when value is `false`' do
      expect(described_class.new(user, locations_directory: { display_active: 'false' }).display_active).to be_falsey
    end

    it 'true for any other value' do
      expect(described_class.new(user, locations_directory: { display_active: '1' }).display_active).to be_truthy
      expect(described_class.new(user, locations_directory: { display_active: 'true' }).display_active).to be_truthy
      expect(described_class.new(user, locations_directory: { display_active: 'apples' }).display_active).to be_truthy
    end
  end

  describe 'display_hidden' do
    it 'default to false when no value is set' do
      expect(described_class.new(user, {}).display_hidden).to be_falsey
    end

    it 'false when value is an empty string' do
      expect(described_class.new(user, locations_directory: { display_hidden: '' }).display_hidden).to be_falsey
    end

    it 'false when value is a`0`' do
      expect(described_class.new(user, locations_directory: { display_hidden: '0' }).display_hidden).to be_falsey
    end

    it 'false when value is `false`' do
      expect(described_class.new(user, locations_directory: { display_hidden: 'false' }).display_hidden).to be_falsey
    end

    it 'true for any other value' do
      expect(described_class.new(user, locations_directory: { display_hidden: '1' }).display_hidden).to be_truthy
      expect(described_class.new(user, locations_directory: { display_hidden: 'true' }).display_hidden).to be_truthy
      expect(described_class.new(user, locations_directory: { display_hidden: 'apples' }).display_hidden).to be_truthy
    end
  end

  describe '#locations' do
    subject { described_class.new(user, params) }

    context 'when hidden location exists' do
      let!(:location) { create(:location, hidden: true) }

      context 'when display_hidden is false' do
        let(:params) { { locations_directory: { display_hidden: false } } }

        it 'hidden location is not returned' do
          expect(subject.locations).to be_empty
        end
      end

      context 'when display_hidden is true' do
        let(:params) { { locations_directory: { display_hidden: true } } }

        it 'hidden location is returned' do
          expect(subject.locations).to contain_exactly(location)
        end
      end
    end

    context 'when active location exists' do
      let!(:location) { create(:location) }

      context 'when display_active is false' do
        let(:params) { { locations_directory: { display_active: false } } }

        it 'active location is not returned' do
          expect(subject.locations).to be_empty
        end
      end

      context 'when display_active is true' do
        let(:params) { { locations_directory: { display_active: true } } }

        it 'active location is returned' do
          expect(subject.locations).to contain_exactly(location)
        end
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
