require "rails_helper"

RSpec.describe Accounting::TotalBalance do
  describe "#value" do
    subject(:total_balance) { described_class.new(accounts, currency).value }

    let(:accounts) { Money::Currency.all.map { |currency| build(:account, currency:) } }
    let(:currency) { Money::Currency.all.sample }
    let(:calculated_balance) { accounts.sum { |account| account.balance.exchange_to(currency) } }

    it { is_expected.to be_an_instance_of(Money) }

    it "returns the total balance of the specified accounts in the specified currency" do
      expect(total_balance).to eql(calculated_balance)
    end

    context "when the specified accounts is empty collection" do
      let(:accounts) { [] }

      it "returns zero amount in the specified currency" do
        expect(total_balance).to eql(Money.zero(currency))
      end
    end
  end
end
