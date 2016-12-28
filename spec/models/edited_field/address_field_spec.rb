require 'rails_helper'

RSpec.describe EditedField::AddressField do
  shared_examples_for 'an address display field' do
    context 'when blank' do
      let(:address) { nil }

      it 'returns an empty string' do
        expect(subject).to eq('')
      end
    end

    context 'when it is an address object without point coordinated' do
      let(:address) { instance_double(Address, to_a: ['Line 1', 'Town', 'Postcode'], point: nil) }

      it 'outputs the address across multiple lines' do
        expect(subject).to include('Line 1<br/>Town<br/>Postcode')
        expect(subject).not_to include('<img')
      end
    end

    context 'when it is an address object with point coordinated' do
      let(:address) do
        instance_double(Address, to_a: ['Line 1', 'Town', 'Postcode'], point: { 'coordinates' => [12, 10] })
      end

      it 'renders the google image' do
        expect(subject).to include('Line 1<br/>Town<br/>Postcode')
        expect(subject).to include('<img')
      end
    end
  end

  describe '#old_value' do
    subject { described_class.new(:address, nil, old_location).old_value }
    let(:old_location) { double(address: address) }

    it_behaves_like 'an address display field'
  end

  describe '#new_value' do
    subject { described_class.new(:address, location, nil).new_value }
    let(:location) { double(address: address) }

    it_behaves_like 'an address display field'
  end
end
