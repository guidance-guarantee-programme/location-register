require 'rails_helper'

RSpec.describe PostcodeGeocoder do
  subject { described_class.new('SE1 9HS') }
  let(:valid_geocode) do
    double(
      :geocode,
      data: { 'address_components' => [{ 'types' => ['postal_code'] }] },
      longitude: -2.000,
      latitude: 52.000
    )
  end
  let(:invalid_geocode) do
    double(
      :geocode,
      data: { 'address_components' => [{ 'types' => ['partial_postcode'] }] },
      longitude: -2.000,
      latitude: 52.000
    )
  end

  describe '#valid?' do
    context 'when geocoder does not return any results' do
      before do
        allow(Geocoder).to receive(:search).and_return([])
      end

      it 'is not valid' do
        expect(subject).not_to be_valid
      end
    end

    context 'when geocoder returns 1 result' do
      context 'and result has a postcode address component' do
        before do
          allow(Geocoder).to receive(:search).and_return([valid_geocode])
        end

        it 'is not valid' do
          expect(subject).to be_valid
        end
      end

      context 'and result does not have a postcode address component' do
        before do
          allow(Geocoder).to receive(:search).and_return([invalid_geocode])
        end

        it 'is not valid' do
          expect(subject).not_to be_valid
        end
      end
    end

    context 'when geocoder returns multiple results' do
      before do
        allow(Geocoder).to receive(:search).and_return([valid_geocode, invalid_geocode])
      end

      it 'is not valid' do
        expect(subject).not_to be_valid
      end
    end
  end

  describe '#corordinates' do
    before do
      allow(Geocoder).to receive(:search).and_return([valid_geocode])
    end

    it 'returns an array containing the longitude and latitude' do
      expect(subject.coordinates).to eq([-2.000, 52.000])
    end
  end
end