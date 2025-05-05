FactoryBot.define do
  factory :account do
    name { %w[Primary Wallet Savings Family Safe Acme].sample }
    balance_cents { rand(1000..100_000).round }
    user

    trait :invalid do
      name { nil }
      balance { -1 }
    end
  end
end
