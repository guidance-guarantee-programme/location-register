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

  describe '#from' do
    subject { described_class.new(object).from }
    let(:object) { double(from: address) }

    it_behaves_like 'an address display field'
  end

  describe '#to' do
    subject { described_class.new(object).to }
    let(:object) { double(to: address) }

    it_behaves_like 'an address display field'
  end
end
