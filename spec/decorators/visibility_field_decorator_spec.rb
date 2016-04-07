require 'rails_helper'

RSpec.describe VisibilityFieldDecorator do
  subject { described_class.new(object) }

  shared_examples_for 'a visibility display field' do
    context 'when blank' do
      let(:value) { nil }

      it 'returns an empty string' do
        expect(subject).to eq('')
      end
    end

    context 'when value is true' do
      let(:value) { true }

      it 'displays hidden' do
        expect(subject).to eq('Hidden')
      end
    end

    context 'when value is false' do
      let(:value) { false }

      it 'displays active' do
        expect(subject).to eq('Active')
      end
    end
  end

  describe '#from' do
    subject { described_class.new(object).from }
    let(:object) { double(from: value) }

    it_behaves_like 'a visibility display field'
  end

  describe '#to' do
    subject { described_class.new(object).to }
    let(:object) { double(to: value) }

    it_behaves_like 'a visibility display field'
  end

  describe '#field' do
    subject { described_class.new(double) }

    it 'displays visibility' do
      expect(subject.field).to eq('visibility')
    end
  end
end
