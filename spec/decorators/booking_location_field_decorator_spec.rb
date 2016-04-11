require 'rails_helper'

RSpec.describe BookingLocationFieldDecorator do
  subject { described_class.new(object) }

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
    subject { described_class.new(object).old_value }
    let(:object) { double(old_value: booking_location) }

    it_behaves_like 'a booking location display field'
  end

  describe '#new_value' do
    subject { described_class.new(object).new_value }
    let(:object) { double(new_value: booking_location) }

    it_behaves_like 'a booking location display field'
  end
end
