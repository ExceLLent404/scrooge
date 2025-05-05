unless Rails.env.test? || User.exists?(email: ENV.fetch("DEMO_USER_EMAIL"))
  include FactoryBot::Syntax::Methods # rubocop:disable Style/MixinUsage

  user = create(:user, name: "Scrooge", email: ENV.fetch("DEMO_USER_EMAIL"), password: ENV.fetch("DEMO_USER_PASS"))

  create(:account, user:, name: "Primary", balance: 100_000)
  create(:account, user:, name: "Wallet", balance: 1234)
  create(:account, user:, name: "Savings", balance: 1_000_000)
end
