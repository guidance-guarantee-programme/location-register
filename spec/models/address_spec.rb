require 'rails_helper'

RSpec.describe Address do
  it 'is initialized with a uid' do
    expect(Address.new.uid).not_to be_nil
  end

  it 'does not corrupt an existing address uid' do
    address_1 = Address.create
    address_2 = Address.find(address_1.id)

    expect(address_1.uid).to eq(address_2.uid)
  end
end
