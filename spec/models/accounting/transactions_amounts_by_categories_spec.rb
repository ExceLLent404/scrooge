require "rails_helper"

RSpec.describe Accounting::TransactionsAmountsByCategories do
  describe "#result" do
    subject(:transactions_amounts_by_categories) { described_class.new(transactions, categories, currency).result }

    let(:transactions) { two_transactions + [one_transaction] }
    let(:two_transactions) do
      transactions = build_stubbed_pair(:transaction, type: category_with_two_transactions.type.sub("Category", ""))
      transactions.each { |transaction| transaction.category = category_with_two_transactions }
      transactions
    end
    let(:one_transaction) do
      transaction = build_stubbed(:transaction, type: category_with_one_transaction.type.sub("Category", ""))
      transaction.category = category_with_one_transaction
      transaction
    end
    let(:categories) { [category_with_two_transactions, category_with_one_transaction, category_without_transactions] }
    let(:category_with_two_transactions) { build_stubbed(:category) }
    let(:category_with_one_transaction) { build_stubbed(:category) }
    let(:category_without_transactions) { build_stubbed(:category) }
    let(:currency) { Money::Currency.all.sample }
    let(:calculated_result) do
      {
        category_with_two_transactions => two_transactions.sum { |transaction| transaction.amount.exchange_to(currency) },
        category_with_one_transaction => one_transaction.amount.exchange_to(currency),
        category_without_transactions => Money.zero(currency)
      }
    end

    it "returns a Hash of pairs {category => Money}" do
      hash = transactions_amounts_by_categories
      expect(hash).to be_an_instance_of(Hash)
      expect(hash).not_to be_empty
      expect(hash.keys).to all(be_a(Category))
      expect(hash.values).to all(be_an_instance_of(Money))
    end

    it "returns the total amounts of the specified transactions in the specified currency, grouped by the specified categories" do
      expect(transactions_amounts_by_categories).to eql(calculated_result)
    end

    context "when the specified transactions is empty collection" do
      let(:transactions) { [] }
      let(:calculated_result) { categories.index_with(Money.zero(currency)) }

      it "returns zero amounts in the specified currency, grouped by the specified categories" do
        expect(transactions_amounts_by_categories).to eql(calculated_result)
      end
    end

    context "when the specified categories is empty collection" do
      let(:categories) { [] }

      it "returns an empty Hash" do
        expect(transactions_amounts_by_categories).to eql({})
      end
    end
  end
end
