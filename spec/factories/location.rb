FactoryGirl.define do
  factory :location do
    uid { SecureRandom.uuid }
    state 'current'
    version 1
    cas
    sequence(:title) { |n| "Alpha location #{n}" }
    address
    sequence(:phone) { |n| "+44100000#{1000 + n}" }
    sequence(:twilio_number) { |n| "+44111111#{1000 + n}" }
    extension nil
    hours 'MON-FRI 9am-5pm'
    booking_location nil
    editor { build(:user) }
    online_booking_enabled false

    before(:create) do |location|
      if location.booking_location.present?
        location.hours = nil
        location.phone = nil
      end
    end

    trait :cas do
      organisation 'cas'
    end

    trait :cita do
      organisation 'cita'
    end

    trait :one_line_address do
      address { build(:one_line_address) }
    end

    trait :nicab do
      organisation 'nicab'
    end

    factory :booking_location do
      online_booking_twilio_number '+441442800110'

      after(:create) do |parent|
        create(:guider, location: parent)

        create_list(:location, 2, booking_location: parent)
      end
    end
  end
end
