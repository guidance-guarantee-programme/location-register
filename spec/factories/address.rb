FactoryGirl.define do
  factory :address do
    uid { SecureRandom.uuid }
    sequence(:address_line_1) { |n| "Test flat #{n}" }
    address_line_2 'Testing centre'
    address_line_3 'Test Avenue'
    town 'Test Vile'
    county 'Testy'
    postcode 'UB9 4LH'
    point do
      {
        type: 'Point',
        coordinates: [12.12, 45.45]
      }.to_json
    end
  end

  factory :one_line_address, class: Address do
    address_line_1 'One line address'
  end
end
