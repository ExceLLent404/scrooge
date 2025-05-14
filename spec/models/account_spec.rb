require "rails_helper"

RSpec.describe Account do
  subject(:account) { build(:account) }

  it { is_expected.to be_an(ApplicationRecord) }

  it { is_expected.to monetize(:balance).with_model_currency(:currency) }

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

  describe "#currency" do
    subject { account.currency }

    it { is_expected.to be_an_instance_of(Money::Currency) }

    it "cannot be absent" do
      expect(build(:account, currency: nil)).not_to be_valid
    end

    it "can be only `USD`, `EUR` or `RUB`" do
      expect(build(:account, currency: Money::Currency.new("USD"))).to be_valid
      expect(build(:account, currency: "EUR")).to be_valid
      expect(build(:account, currency: :rub)).to be_valid
      expect(build(:account, currency: "GBP")).not_to be_valid
      expect(build(:account, currency: "ABC")).not_to be_valid
    end
  end

  describe "#deposit" do
    subject(:command) { account.deposit(amount) }

    let(:amount) { Money.from_amount(100, account.currency) }

    it "increases the balance by the specified amount" do
      expect { command }.to change(account, :balance).by(amount)
    end

    context "when the specified amount is negative" do
      let(:amount) { Money.from_amount(-1, account.currency) }

      it "raises Account::NegativeAmount error" do
        expect { command }.to raise_error(Account::NegativeAmount)
      end

      it "does not increase the balance" do
        expect { suppress(Account::NegativeAmount) { command } }.not_to change(account, :balance)
      end
    end
  end

  describe "#withdraw" do
    subject(:command) { account.withdraw(amount) }

    let(:amount) { account.balance }
    let(:account) { build(:account, balance: 100) }

    it "decreases the balance by the specified amount" do
      expect { command }.to change(account, :balance).by(-amount)
    end

    context "when the specified amount is negative" do
      let(:amount) { Money.from_amount(-1, account.currency) }

      it "raises Account::NegativeAmount error" do
        expect { command }.to raise_error(Account::NegativeAmount)
      end

      it "does not decrease the balance" do
        expect { suppress(Account::NegativeAmount) { command } }.not_to change(account, :balance)
      end
    end

    context "when the specified amount is greater than the balance" do
      let(:amount) { account.balance + Money.from_amount(1, account.currency) }

      it "raises Account::NotEnoughBalance error" do
        expect { command }.to raise_error(Account::NotEnoughBalance)
      end

      it "does not decrease the balance" do
        expect { suppress(Account::NotEnoughBalance) { command } }.not_to change(account, :balance)
      end
    end
  end
end
