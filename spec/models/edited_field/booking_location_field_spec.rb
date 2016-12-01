require 'rails_helper'

RSpec.describe EditedField::BookingLocationField do
  shared_examples_for 'a booking location display field' do
    context 'when blank' do
      let(:booking_location) { nil }

      it 'returns an empty string' do
        expect(subject).to eq('')
      end
    end

    context 'when it is a booking location object' do
      let(:booking_location) { instance_double(Location, title: 'Parent Location') }

      it 'outputs the booking location title' do
        expect(subject).to eq('Parent Location')
      end
    end
  end

  describe '#old_value' do
    subject { described_class.new(:booking_location, nil, old_location).old_value }
    let(:old_location) { double(booking_location: booking_location) }

    it_behaves_like 'a booking location display field'
  end

  describe '#new_value' do
    subject { described_class.new(:booking_location, location, nil).new_value }
    let(:location) { double(booking_location: booking_location) }

    it_behaves_like 'a booking location display field'
  end
end
