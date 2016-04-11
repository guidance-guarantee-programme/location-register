require 'rails_helper'

RSpec.describe AddressFieldDecorator do
  subject { described_class.new(object) }

  shared_examples_for 'an address display field' do
    context 'when blank' do
      let(:address) { nil }

      it 'returns an empty string' do
        expect(subject).to eq('')
      end
    end

    context 'when it is an address object' do
      let(:address) { instance_double(Address, to_a: ['Line 1', 'Town', 'Postcode']) }

      it 'outputs the address across multiple lines' do
        expect(subject).to eq('Line 1<br/>Town<br/>Postcode')
      end
    end
  end

  describe '#old_value' do
    subject { described_class.new(object).old_value }
    let(:object) { double(old_value: address) }

    it_behaves_like 'an address display field'
  end

  describe '#new_value' do
    subject { described_class.new(object).new_value }
    let(:object) { double(new_value: address) }

    it_behaves_like 'an address display field'
  end
end
