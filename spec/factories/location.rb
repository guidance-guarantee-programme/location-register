FactoryGirl.define do
  factory :location do
    uid { SecureRandom.uuid }
    state 'current'
    version 1
    cas
    sequence(:title) { |n| "Alpha location #{n}" }
    address
    phone '01111111111'
    hours 'MON-FRI 9am-5pm'
    booking_location nil

    trait :nicab do
      organisation 'nicab'
    end

    trait :citi do
      organisation 'citi'
    end

    trait :cas do
      organisation 'cas'
    end
  end
end
