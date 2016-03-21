FactoryGirl.define do
  factory :location do
    uid { SecureRandom.uuid }
    state 'current'
    version 1
    organisation 'CAS'
    title 'Test Vile'
    address
    phone '01111111111'
    hours 'MON-FRI 9am-5pm'
    booking_location nil
  end
end
