require "rails_helper"

RSpec.describe Expense do
  subject(:expense) { build(:expense) }

  it { is_expected.to be_a(Transaction) }

  describe "#type" do
    it "can be only `Expense`" do
      expect(expense.type).to eql("Expense")

      expense.type = "Income"
      expect(expense).not_to be_valid
    end
  end

  describe "#perform" do
    subject(:command) { expense.perform }

    let(:expense) { build(:expense, user:, source: account, amount:) }
    let(:account) { build(:account, user:, balance: 100) }
    let(:user) { build(:user) }
    let(:amount) { account.balance }

    it "decreases the Account balance by the Expense amount" do
      expect { command }.to change(account, :balance).by(-expense.amount)
    end

    context "when Expense amount is greater than Account balance" do
      let(:amount) { account.balance + Money.from_amount(1, account.currency) }

      it "raises Account::NotEnoughBalance error" do
        expect { command }.to raise_error(Account::NotEnoughBalance)
      end

      it "does not decrease the Account balance" do
        expect { suppress(Account::NotEnoughBalance) { command } }.not_to change(account, :balance)
      end
    end
  end

  describe "#correct" do
    subject(:command) { expense.correct(new_amount) }

    let(:expense) { build(:expense, user:, source: account, amount: account.balance) }
    let(:account) { build(:account, user:, balance: 100) }
    let(:user) { build(:user) }
    let(:new_amount) { expense.amount + diff }

    context "when the new amount is greater than the current one" do
      let(:diff) { Money.from_amount(1, account.currency) }

      it "decreases the Account balance by the difference between the new and current amounts" do
        expect { command }.to change(account, :balance).by(-diff)
      end

      context "when the difference between the new and current amounts is greater than Account balance" do
        let(:diff) { account.balance + Money.from_amount(1, account.currency) }

        it "raises Account::NotEnoughBalance error" do
          expect { command }.to raise_error(Account::NotEnoughBalance)
        end

        it "does not decrease the Account balance" do
          expect { suppress(Account::NotEnoughBalance) { command } }.not_to change(account, :balance)
        end
      end
    end

    context "when the new amount is equal to the current one" do
      let(:diff) { Money.zero(account.currency) }

      it "does not change the Account balance" do
        expect { command }.not_to change(account, :balance)
      end
    end

    context "when the new amount is less than the current one" do
      let(:diff) { Money.from_amount(-1, account.currency) }

      it "increases the Account balance by the difference between the new and current amounts" do
        expect { command }.to change(account, :balance).by(diff.abs)
      end
    end
  end

  describe "#cancel" do
    subject(:command) { expense.cancel }

    it "increases the Account balance by the Expense amount" do
      expect { command }.to change { expense.account.balance }.by(expense.amount)
    end
  end

  describe "Associations" do
    let(:income_category) { build(:income_category) }
    let(:account) { build(:account) }
    let(:expense_category) { build(:expense_category) }

    describe "#source" do
      it "can be only an Account" do
        expect(build(:expense, source: account)).to be_valid
        expect(build(:expense, source: income_category)).not_to be_valid
        expect(build(:expense, source: expense_category)).not_to be_valid
      end
    end

    describe "#destination" do
      it "can be only an ExpenseCategory" do
        expect(build(:expense, destination: expense_category)).to be_valid
        expect(build(:expense, destination: income_category)).not_to be_valid
        expect(build(:expense, destination: account)).not_to be_valid
      end
    end

    describe "#category" do
      subject { expense.category }

      it { is_expected.to be_an_instance_of(ExpenseCategory) }
    end

    describe "#account" do
      subject { expense.account }

      it { is_expected.to be_an_instance_of(Account) }
    end
  end
end
