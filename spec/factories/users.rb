FactoryBot.define do
  factory :user do
    name { [Faker::Name.first_name, nil].sample }
    email { Faker::Internet.email }
    password { Faker::Internet.password }

    confirmed

    trait :with_name do
      name { Faker::Name.first_name }
    end

    trait :confirmed do
      confirmed_at { Time.current }
    end

    trait :unconfirmed do
      confirmed_at { nil }
    end
  end
end
