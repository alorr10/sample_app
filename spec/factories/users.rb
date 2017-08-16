FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    name  { Faker::Name.name }
    password { User.digest(Faker::Internet.password) }
    activated { true }
    activated_at { Time.zone.now }

    trait :admin do
      admin true
    end

    trait :not_activated do
      activated { false }
      activated_at { nil }
    end

    trait :reset_token do
      reset_token { User.new_token }
    end
  end
end
