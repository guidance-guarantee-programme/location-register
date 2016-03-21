FactoryGirl.define do
  factory :address do
    uid { SecureRandom.uuid }
    address 'Flat 10'
    address_line_1 'Test flat 3'
    address_line_2 'Testing center'
    address_line_3 'Test Avenue'
    town 'Test Vile'
    county 'Testy'
    postcode 'TT11 35AA'
    point do
      {
        type: 'Point',
        coordinates: [12.12, 45.45]
      }.to_json
    end
  end
end
