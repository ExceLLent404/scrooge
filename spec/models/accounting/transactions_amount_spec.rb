require "rails_helper"

RSpec.describe Accounting::TransactionsAmount do
  describe "#value" do
    subject(:transactions_amount) { described_class.new(transactions, currency).value }

    let(:transactions) { build_pair(:transaction) }
    let(:currency) { Money::Currency.all.sample }
    let(:calculated_amount) { transactions.sum { |transaction| transaction.amount.exchange_to(currency) } }

    it { is_expected.to be_an_instance_of(Money) }

    it "returns the total amount of the specified transactions in the specified currency" do
      expect(transactions_amount).to eql(calculated_amount)
    end

    context "when the specified transactions is empty collection" do
      let(:transactions) { [] }

      it "returns zero amount in the specified currency" do
        expect(transactions_amount).to eql(Money.zero(currency))
      end
    end
  end
end
