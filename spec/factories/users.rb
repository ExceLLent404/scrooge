FactoryBot.define do
  factory :user do
    name { [Faker::Name.first_name, nil].sample }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    preferred_currency { Money::Currency.all.sample }
    time_zone { ActiveSupport::TimeZone.all.sample.name }

    confirmed

    trait :with_name do
      name { Faker::Name.first_name }
    end

    trait :without_name do
      name { nil }
    end

    trait :confirmed do
      confirmed_at { Time.current }
    end

    trait :unconfirmed do
      confirmed_at { nil }
    end
  end
end
