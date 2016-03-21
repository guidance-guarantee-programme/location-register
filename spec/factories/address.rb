FactoryGirl.define do
  factory :address do
    uid { SecureRandom.uuid }
    address "Flat 10"
    address_line_1 "Test Avenue"
    address_line_2 ""
    address_line_3 ""
    town "Test Vile"
    county ""
    postcode "TT11 35AA"
    point do
      {
        type: "Point",
        coordinates: [12.12, 45.45]
      }.to_json
    end
  end
end
