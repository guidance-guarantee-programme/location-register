require 'rails_helper'

RSpec.describe Address do
  describe '#initialization' do
    before do
      allow(PostcodeGeocoder).to receive(:new).and_return(geocode)
    end

    context 'when geocode lookup works' do
      let(:geocode) { instance_double('PostcodeGeocoder', valid?: true, coordinates: [-2.000, 52.000]) }

      it 'is initialized with a uid' do
        expect(Address.new.uid).not_to be_nil
      end

      it 'does not corrupt an existing address uid' do
        address_1 = create(:address, point: nil)
        address_2 = Address.find(address_1.id)

        expect(address_1.uid).to eq(address_2.uid)
      end
    end

    context 'when geocode lookup fails' do
      let(:geocode) { instance_double('PostcodeGeocoder', valid?: false) }

      it 'does not save the record' do
        address = Address.create(postcode: 'AA1 2BB', address_line_1: 'line 1')
        expect(address).to be_new_record
      end
    end
  end

  describe '#to_a' do
    it 'returns an array of address components' do
      address = build(:address)
      expect(address.to_a).to eq(
        [
          'Test flat 3',
          'Testing center',
          'Test Avenue',
          'Test Vile',
          'Testy',
          'UB9 4LH'
        ]
      )
    end

    it 'skips does not include blank components' do
      address = Address.new(
        address_line_1: '23 Test road',
        town: 'West town',
        postcode: 'TT1 1TT'
      )
      expect(address.to_a).to eq(
        [
          '23 Test road',
          'West town',
          'TT1 1TT'
        ]
      )
    end
  end

  describe 'validations' do
    subject { described_class.new(params).tap(&:valid?) }
    let(:geocode) { instance_double('PostcodeGeocoder', valid?: false) }

    before do
      allow(PostcodeGeocoder).to receive(:new).and_return(geocode)
    end

    context 'when postcode is present' do
      context 'and is a valid UK postcode' do
        let(:params) { { postcode: 'AA1 2BB' } }

        it 'raises a validation around geocoding' do
          expect(subject.errors).to be_added(:postcode, :geocoding_error)
        end
      end

      context 'and is not a valid UK postcode' do
        let(:params) { { postcode: 'APPLES' } }

        it 'raise a validation around postcode not being valid' do
          expect(subject.errors).to be_added(:postcode, :non_uk)
        end

        it 'it does not raise a validation around geocoding' do
          expect(subject.errors).not_to be_added(:postcode, :geocoding_error)
        end
      end
    end

    context 'when postcode is not present' do
      let(:params) { { postcode: nil } }

      it 'raise a validation around postcode is blank' do
        expect(subject.errors).to be_added(:postcode, :blank)
      end

      it 'it does not raise a validation around geocoding' do
        expect(subject.errors).not_to be_added(:postcode, :geocoding_error)
      end
    end
  end
end
