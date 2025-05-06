require "rails_helper"

RSpec.describe Account do
  subject(:account) { build(:account) }

  it { is_expected.to be_an(ApplicationRecord) }

  it { is_expected.to monetize(:balance) }

  it_behaves_like "it has name"
  it_behaves_like "it has timestamps"

  describe "#balance_cents" do
    subject(:balance_cents) { account.balance_cents }

    it { is_expected.to be_an_instance_of(Integer) }

    it "cannot be absent" do
      expect(build(:account, balance_cents: nil)).not_to be_valid
    end

    it "is >= 0" do
      expect(balance_cents).to be >= 0
      expect(build(:account, balance_cents: -1)).not_to be_valid
    end
  end

  describe "#balance" do
    subject(:balance) { account.balance }

    it { is_expected.to be_an_instance_of(Money) }

    it "is >= 0" do
      expect(balance).to be >= 0
      expect(build(:account, balance: -1)).not_to be_valid
    end
  end
end
