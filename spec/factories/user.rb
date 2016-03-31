FactoryGirl.define do
  factory :user do
    name 'Test user'
    email 'test@test.com'
    uid { SecureRandom.uuid }
    organisation_slug 'hm-treasury'
    organisation_content_id { SecureRandom.uuid }
    permissions { ['signin'] }
    remotely_signed_out false
    disabled false

    trait :cas do
      organisation_slug 'cas'
    end

    trait :nicab do
      organisation_slug 'nicab'
    end

    trait :pensionwise_admin do
      permissions { %w(signin pensionwise_admin) }
    end

    trait :project_manager do
      permissions { %w(signin project_manager) }
    end
  end
end
