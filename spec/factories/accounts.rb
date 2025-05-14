FactoryBot.define do
  factory :account do
    name { %w[Primary Wallet Savings Family Safe Acme].sample }
    balance { rand(0.0..100.0).round(2) }
    currency { Money::Currency.all.sample }
    user

    trait :invalid do
      name { nil }
      balance { -1 }
    end
  end
end
