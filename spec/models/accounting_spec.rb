require "rails_helper"

RSpec.shared_examples "calculations with invalid currency" do
  context "when accounting is invalid due to currency" do
    let(:accounting) { build(:accounting, currency: "ABC") }

    it "returns zero amount in the application default currency" do
      expect(subject).to eql(Money.zero)
    end
  end
end

RSpec.shared_examples "calculations with invalid period" do
  context "when accounting is invalid due to period" do
    let(:accounting) { build(:accounting, :with_invalid_period) }

    it "returns zero amount in the accounting currency" do
      expect(subject).to eql(Money.zero(accounting.currency))
    end
  end
end

RSpec.describe Accounting do
  subject(:accounting) { build(:accounting) }

  it { is_expected.to be_an(ActiveModel::Model) }

  describe "#user" do
    subject(:user) { accounting.user }

    it "is a User" do
      expect(user).to be_an_instance_of(User)

      accounting.user = 1
      expect(accounting).not_to be_valid
    end

    it "cannot be absent" do
      expect(build(:accounting, user: nil)).not_to be_valid
    end
  end

  describe "#currency" do
    subject(:currency) { accounting.currency }

    include_examples "of currency available to use", :currency

    context "by default" do
      let(:accounting) { described_class.new(user:) }
      let(:user) { build(:user) }

      it "is the user preferred currency" do
        expect(currency).to eql(user.preferred_currency)
      end
    end
  end

  describe "#from" do
    subject(:from) { accounting.from }

    it { is_expected.to be_an_instance_of(Date) }

    context "by default" do
      let(:accounting) { described_class.new }

      it "is the beginning of the current month" do
        expect(from).to eql(Date.current.beginning_of_month)
      end
    end

    it "cannot be greater than the current date" do
      expect(build(:accounting, from: Date.tomorrow)).not_to be_valid
    end

    it "cannot be greater than #to" do
      expect(build(:accounting, from: Date.current, to: Date.yesterday)).not_to be_valid
    end
  end

  describe "#to" do
    subject(:to) { accounting.to }

    it { is_expected.to be_an_instance_of(Date) }

    context "by default" do
      let(:accounting) { described_class.new }

      it "is the current date" do
        expect(to).to eql(Date.current)
      end
    end

    it "cannot be greater than the current date" do
      expect(build(:accounting, to: Date.tomorrow)).not_to be_valid
    end
  end

  describe "#total_funds" do
    subject(:total_funds) { accounting.total_funds }

    let(:user) { accounting.user }

    it { is_expected.to be_an_instance_of(Money) }

    context "when user has accounts" do
      before { user.accounts = Money::Currency.all.map { |currency| build(:account, user:, currency:) } }

      let(:calculated_amount) { user.accounts.sum { |account| account.balance.exchange_to(accounting.currency) } }

      it "returns the total amount of funds from all user accounts in the accounting currency" do
        expect(total_funds).to eql(calculated_amount)
      end
    end

    context "when user has no accounts" do
      it "returns zero amount in the accounting currency" do
        expect(total_funds).to eql(Money.zero(accounting.currency))
      end
    end

    it_behaves_like "calculations with invalid currency"
  end

  describe "#incomes_amount" do
    subject(:incomes_amount) { accounting.incomes_amount }

    it { is_expected.to be_an_instance_of(Money) }

    context "when user has incomes for the accounting period" do
      let!(:incomes) { [accounting.from, accounting.to].map { |date| create(:income, user: accounting.user, committed_date: date) } }
      let(:calculated_amount) { incomes.sum { |income| income.amount.exchange_to(accounting.currency) } }

      it "returns the total amount of all user incomes for the accounting period in the accounting currency" do
        expect(incomes_amount).to eql(calculated_amount)
      end
    end

    context "when user has no incomes for the accounting period" do
      it "returns zero amount in the accounting currency" do
        expect(incomes_amount).to eql(Money.zero(accounting.currency))
      end
    end

    it_behaves_like "calculations with invalid currency"
    it_behaves_like "calculations with invalid period"
  end

  describe "#expenses_amount" do
    subject(:expenses_amount) { accounting.expenses_amount }

    it { is_expected.to be_an_instance_of(Money) }

    context "when user has expenses for the accounting period" do
      let!(:expenses) { [accounting.from, accounting.to].map { |date| create(:expense, user: accounting.user, committed_date: date) } }
      let(:calculated_amount) { expenses.sum { |expense| expense.amount.exchange_to(accounting.currency) } }

      it "returns the total amount of all user expenses for the accounting period in the accounting currency" do
        expect(expenses_amount).to eql(calculated_amount)
      end
    end

    context "when user has no expenses for the accounting period" do
      it "returns zero amount in the accounting currency" do
        expect(expenses_amount).to eql(Money.zero(accounting.currency))
      end
    end

    it_behaves_like "calculations with invalid currency"
    it_behaves_like "calculations with invalid period"
  end

  describe "#transactions_amount_by_category" do
    subject(:transactions_amount) { accounting.transactions_amount_by_category(category) }

    let(:type) { %i[income expense].sample }
    let(:category) { build(:"#{type}_category", user: accounting.user) }
    let(:source_or_destination) { (type == :income) ? :source : :destination }

    it { is_expected.to be_an_instance_of(Money) }

    context "when user has transactions for the specified category for the accounting period" do
      let!(:transactions) do
        [accounting.from, accounting.to].map do |date|
          create(type, :user => accounting.user, source_or_destination => category, :committed_date => date)
        end
      end
      let(:calculated_amount) { transactions.sum { |transaction| transaction.amount.exchange_to(accounting.currency) } }

      it "returns the total amount of all transactions for the specified category for the accounting period in the accounting currency" do
        expect(transactions_amount).to eql(calculated_amount)
      end
    end

    context "when user has no transactions for the specified category for the accounting period" do
      before do
        category.save! # important for the category not to be just created
        create(type, :user => accounting.user, source_or_destination => category, :committed_date => accounting.from.prev_day)
        create(:transaction, user: accounting.user, committed_date: accounting.to)
      end

      it "returns zero amount in the accounting currency" do
        expect(transactions_amount).to eql(Money.zero(accounting.currency))
      end
    end

    context "when the specified category was just created" do
      before { category.save! }

      it "returns zero amount in the accounting currency" do
        expect(transactions_amount).to eql(Money.zero(accounting.currency))
      end
    end

    it_behaves_like "calculations with invalid currency"
    it_behaves_like "calculations with invalid period"
  end

  describe "#transactions_amounts_by_categories" do
    subject(:transactions_amounts) { accounting.transactions_amounts_by_categories(categories) }

    let(:categories) { [category_with_two_transactions, category_with_one_transaction, category_without_transactions] }
    let(:category_with_two_transactions) { build(:category, user: accounting.user) }
    let(:category_with_one_transaction) { build(:category, user: accounting.user) }
    let(:category_without_transactions) { build(:category, user: accounting.user) }
    let(:transactions) { two_transactions + [one_transaction] }
    let(:two_transactions) do
      transactions = [accounting.from, accounting.to].map do |date|
        build(:transaction, type: category_with_two_transactions.type.sub("Category", ""), user: accounting.user, committed_date: date)
      end
      transactions.each { |transaction| transaction.category = category_with_two_transactions }
      transactions
    end
    let(:one_transaction) do
      transaction = build(:transaction, type: category_with_one_transaction.type.sub("Category", ""), user: accounting.user, committed_date: accounting.from)
      transaction.category = category_with_one_transaction
      transaction
    end
    let(:calculated_result) do
      {
        category_with_two_transactions => two_transactions.sum { |transaction| transaction.amount.exchange_to(accounting.currency) },
        category_with_one_transaction => one_transaction.amount.exchange_to(accounting.currency),
        category_without_transactions => Money.zero(accounting.currency)
      }
    end

    it "returns a Hash of pairs {category => Money}" do
      categories.each(&:save!)
      transactions.each(&:save!)

      hash = transactions_amounts
      expect(hash).to be_an_instance_of(Hash)
      expect(hash).not_to be_empty
      expect(hash.keys).to all(be_a(Category))
      expect(hash.values).to all(be_an_instance_of(Money))
    end

    it "returns the total amounts of user transactions in the accounting currency, grouped by the specified categories" do
      categories.each(&:save!)
      transactions.each(&:save!)

      expect(transactions_amounts).to eql(calculated_result)
    end

    context "when the specified categories is empty collection" do
      let(:categories) { [] }

      it "returns an empty Hash" do
        expect(transactions_amounts).to eql({})
      end
    end

    context "when user has no transactions for the specified categories for the accounting period" do
      let(:calculated_result) { categories.index_with(Money.zero(accounting.currency)) }

      before do
        categories.each(&:save!)
        create(:transaction, type: categories[0].type.sub("Category", ""), user: accounting.user, committed_date: accounting.from.prev_day)
        create(:transaction, user: accounting.user, committed_date: accounting.from)
      end

      it "returns a Hash with zero amounts in the accounting currency, grouped by the specified categories" do
        expect(transactions_amounts).to eql(calculated_result)
      end
    end

    context "when accounting is invalid due to currency" do
      let(:accounting) { build(:accounting, currency: "ABC") }

      it "returns a Hash with zero amounts in the application default currency" do
        expect(transactions_amounts.values).to all(eql(Money.zero))
      end
    end

    context "when accounting is invalid due to period" do
      let(:accounting) { build(:accounting, :with_invalid_period) }

      it "returns a Hash with zero amounts in the accounting currency" do
        expect(transactions_amounts.values).to all(eql(Money.zero(accounting.currency)))
      end
    end
  end
end
