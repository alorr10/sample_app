FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    name  { Faker::Name.name }
    password { User.digest(Faker::Internet.password) }
  end

  trait :admin do
    admin true
  end
end
