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
    editor { FactoryGirl.build(:user) }

    trait :cas do
      organisation 'cas'
    end

    trait :citi do
      organisation 'citi'
    end

    trait :one_line_address do
      address { FactoryGirl.build(:one_line_address) }
    end

    trait :nicab do
      organisation 'nicab'
    end
  end
end
