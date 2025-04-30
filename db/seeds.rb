unless Rails.env.test? || User.exists?(email: ENV.fetch("DEMO_USER_EMAIL"))
  include FactoryBot::Syntax::Methods # rubocop:disable Style/MixinUsage

  create(:user, name: "Scrooge", email: ENV.fetch("DEMO_USER_EMAIL"), password: ENV.fetch("DEMO_USER_PASS"))
end
