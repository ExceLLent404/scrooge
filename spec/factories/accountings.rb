FactoryBot.define do
  factory :accounting do
    skip_create

    user
    from { Faker::Date.between(from: Date.current.beginning_of_year.prev_year, to:) }
    to { Faker::Date.between(from: Date.current.beginning_of_year.prev_year, to: Date.current) }

    trait :with_invalid_period do
      from { Date.current }
      to { Date.yesterday }
    end
  end
end
