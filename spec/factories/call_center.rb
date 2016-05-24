FactoryGirl.define do
  factory :call_centre do
    uid { SecureRandom.uuid }
    sequence(:purpose) { |n| "Promotion #{n}" }
    sequence(:phone) { |n| "+44100000#{1000 + n}" }
    sequence(:twilio_number) { |n| "+44111111#{1000 + n}" }
  end
end
