require 'rails_helper'

RSpec.describe Address do
  describe '#initialization' do
    it 'is initialized with a uid' do
      expect(Address.new.uid).not_to be_nil
    end

    it 'does not corrupt an existing address uid' do
      address_1 = Address.create
      address_2 = Address.find(address_1.id)

      expect(address_1.uid).to eq(address_2.uid)
    end
  end

  describe '#to_a' do
    it 'returns an array of address components' do
      address = FactoryGirl.build(:address)
      expect(address.to_a).to eq(
        [
          'Test flat 3',
          'Testing center',
          'Test Avenue',
          'Test Vile',
          'Testy',
          'TT11 35AA'
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
end
