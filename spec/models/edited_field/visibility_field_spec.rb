require 'rails_helper'

RSpec.describe EditedField::VisibilityField do
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

  describe '#old_value' do
    subject { described_class.new(:hidden, nil, old_location).old_value }
    let(:old_location) { double(hidden: value) }

    it_behaves_like 'a visibility display field'
  end

  describe '#new_value' do
    subject { described_class.new(:hidden, location, nil).new_value }
    let(:location) { double(hidden: value) }

    it_behaves_like 'a visibility display field'
  end

  describe '#field' do
    subject { described_class.new(:hidden, nil, nil) }

    it 'displays visibility' do
      expect(subject.field).to eq('visibility')
    end
  end
end
