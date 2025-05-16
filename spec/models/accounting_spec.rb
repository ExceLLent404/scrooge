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
end
