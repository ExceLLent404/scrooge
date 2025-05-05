FactoryBot.define do
  factory :category do
    initialize_with { new(type:) }

    type { %w[IncomeCategory ExpenseCategory].sample }

    name do
      case type
      when "IncomeCategory" then %w[Salary Interest Rent Sales Gifts].sample
      when "ExpenseCategory" then %w[Food Health Home Clothes Entertainment].sample
      else "Category"
      end
    end

    user

    trait :invalid do
      name { nil }
    end

    factory :income_category do
      type { "IncomeCategory" }
    end

    factory :expense_category do
      type { "ExpenseCategory" }
    end
  end
end
