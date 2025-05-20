if Rails.env.development? && !User.exists?(email: ENV.fetch("DEMO_USER_EMAIL"))
  include FactoryBot::Syntax::Methods # rubocop:disable Style/MixinUsage

  user = create(:user, name: "Scrooge", email: ENV.fetch("DEMO_USER_EMAIL"), password: ENV.fetch("DEMO_USER_PASS"))

  primary_account = create(:account, user:, name: "Primary", balance: 100_000)
  create(:account, user:, name: "Wallet", balance: 1234)
  savings_account = create(:account, user:, name: "Savings", balance: 1_000_000)

  salary_income_category = create(:income_category, user:, name: "Salary")
  interest_income_category = create(:income_category, user:, name: "Interest")
  create(:income_category, user:, name: "Gifts")

  food_expense_category = create(:expense_category, user:, name: "Food")
  home_expense_category = create(:expense_category, user:, name: "Home")
  health_expense_category = create(:expense_category, user:, name: "Health")
  clothes_expense_category = create(:expense_category, user:, name: "Clothes")
  create(:expense_category, user:, name: "Entertainment")

  10.times { create(:income, user:, source: salary_income_category, destination: primary_account, amount: rand(100_000.0..300_000.0).round(2), comment: nil) }
  create_list(:income, 5, user:, source: interest_income_category, destination: savings_account, comment: nil)

  10.times { create(:expense, user:, source: primary_account, destination: food_expense_category, comment: Faker::Food.ingredient) }
  10.times { create(:expense, user:, source: primary_account, destination: home_expense_category, comment: Faker::House.furniture.capitalize) }
  create_list(:expense, 5, user:, source: primary_account, destination: health_expense_category, comment: nil)
  create_list(:expense, 5, user:, source: primary_account, destination: clothes_expense_category, comment: nil)
end
