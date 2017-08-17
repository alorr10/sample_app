FactoryGirl.define do
  factory :micropost do
    content { Faker::HarryPotter.quote[0..139] }
    association :user, factory: :user
    created_at { Faker::Date.between(8.days.ago, Date.today) }


    trait :most_recent do
      created_at Time.now
    end

  end
end
