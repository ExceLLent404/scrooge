unless Rails.env.test? || User.exists?(email: ENV.fetch("DEMO_USER_EMAIL"))
  include FactoryBot::Syntax::Methods # rubocop:disable Style/MixinUsage

  user = create(:user, name: "Scrooge", email: ENV.fetch("DEMO_USER_EMAIL"), password: ENV.fetch("DEMO_USER_PASS"))

  create(:account, user:, name: "Primary", balance_cents: 10_000_000)
  create(:account, user:, name: "Wallet", balance_cents: 123400)
  create(:account, user:, name: "Savings", balance_cents: 100_000_000)
end
