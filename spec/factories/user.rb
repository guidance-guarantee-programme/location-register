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

    trait :project_manager do
      permissions { ['signin', 'project-manager'] }
    end

    trait :nicab do
      organisation_slug 'nicab'
    end
  end
end
