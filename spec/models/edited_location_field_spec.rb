require 'rails_helper'

RSpec.describe EditedLocationField do
  describe '#all' do
    subject { described_class }

    describe '.all' do
      let(:current) { location(title: 'Beta') }
      let(:previous) { location(title: 'Alpha') }

      it 'returns an edit record for each field that has changed' do
        results = subject.all(current, previous)
        expect(results.count).to eq(1)
      end

      context 'returned object is correctly populated can on edit details' do
        it 'for the field that is changed' do
          results = subject.all(current, previous)
          expect(results[0].field).to eq('title')
        end

        it 'for the old value' do
          results = subject.all(current, previous)
          expect(results[0].old_value).to eq('Alpha')
        end

        it 'for the new value' do
          results = subject.all(current, previous)
          expect(results[0].new_value).to eq('Beta')
        end

        it 'for the creation time' do
          results = subject.all(current, previous)
          expect(results[0].created_at).to be_a(Time)
        end

        it 'for the editor' do
          results = subject.all(current, previous)
          expect(results[0].editor).to be_a(User)
        end
      end

      context 'when no previous record' do
        let(:previous) { nil }

        it 'set the old value to nil' do
          results = subject.all(current, previous)
          expect(results[0].old_value).to be_nil
        end
      end

      context 'when changed field is not important to the user' do
        it 'ignores the edit' do
          results = subject.all(location(version: 1), location(version: 2))
          expect(results).to be_empty
        end
      end

      context 'result is decorated for special fields' do
        it 'hidden field' do
          results = subject.all(location, location(hidden: true))
          expect(results[0]).to be_a(VisibilityFieldDecorator)
        end

        it 'address field' do
          results = subject.all(location, location(address: FactoryGirl.build(:address)))
          expect(results[0]).to be_a(AddressFieldDecorator)
        end

        it 'booking_location field' do
          results = subject.all(location, location(booking_location: FactoryGirl.build(:location)))
          expect(results[0]).to be_a(BookingLocationFieldDecorator)
        end
      end
    end
  end

  def location(attributes = {})
    base_attributes = {
      created_at: Time.zone.now,
      editor: User.new(name: 'Primary editor')
    }
    Location.new(base_attributes.merge(attributes))
  end
end
