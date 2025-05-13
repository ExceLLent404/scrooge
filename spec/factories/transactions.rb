FactoryBot.define do
  factory :transaction do
    initialize_with do
      if abstract
        case type
        when "Income" then build(:income)
        when "Expense" then build(:expense)
        else new(type:)
        end
      else
        new(type:)
      end
    end

    type { %w[Income Expense].sample }
    amount { rand(1.01..100.0).round(2) } # 1.01 is the minimum value that can be decreased by 1 without becoming an invalid transaction amount
    comment { ["Comment", nil].sample }
    committed_date { Faker::Date.between(from: Date.current.beginning_of_year.prev_year, to: Date.current) }
    user

    trait :invalid do
      amount { 0 }
      committed_date { Date.tomorrow }
    end

    transient { abstract { true } }

    after(:build) do |transaction, context|
      transaction.source.user = context.user if transaction.source
      transaction.destination.user = context.user if transaction.destination
    end

    before(:create) do |transaction|
      if transaction.source && transaction.destination
        transaction.source.save!
        transaction.destination.save!
      end
    end

    factory :income do
      type { "Income" }
      source factory: :income_category, strategy: :build
      destination factory: :account, strategy: :build

      transient { abstract { false } }
    end

    factory :expense do
      type { "Expense" }
      source factory: :account, strategy: :build
      destination factory: :expense_category, strategy: :build

      transient { abstract { false } }
    end
  end
end
