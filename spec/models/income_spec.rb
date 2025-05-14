require "rails_helper"

RSpec.describe Income do
  subject(:income) { build(:income) }

  it { is_expected.to be_a(Transaction) }

  describe "#type" do
    it "can be only `Income`" do
      expect(income.type).to eql("Income")

      income.type = "Expense"
      expect(income).not_to be_valid
    end
  end

  describe "#perform" do
    subject(:command) { income.perform }

    it "increases the Account balance by the Income amount" do
      expect { command }.to change { income.account.balance }.by(income.amount)
    end
  end

  describe "#correct" do
    subject(:command) { income.correct(new_amount) }

    let(:income) { build(:income, user:, destination: account, amount: account.balance) }
    let(:account) { build(:account, user:, balance: 100) }
    let(:user) { build(:user) }
    let(:new_amount) { income.amount + diff }

    context "when the new amount is greater than the current one" do
      let(:diff) { Money.from_amount(1, account.currency) }

      it "increases the Account balance by the difference between the new and current amounts" do
        expect { command }.to change(account, :balance).by(diff)
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

      it "decreases the Account balance by the difference between the new and current amounts" do
        expect { command }.to change(account, :balance).by(diff)
      end

      context "when the difference between the new and current amounts is greater than Account balance" do
        let(:diff) { -(account.balance + Money.from_amount(1, account.currency)) }

        it "raises Account::NotEnoughBalance error" do
          expect { command }.to raise_error(Account::NotEnoughBalance)
        end

        it "does not decrease the Account balance" do
          expect { suppress(Account::NotEnoughBalance) { command } }.not_to change(account, :balance)
        end
      end
    end
  end

  describe "#cancel" do
    subject(:command) { income.cancel }

    let(:income) { build(:income, user:, destination: account, amount:) }
    let(:account) { build(:account, user:, balance: 100) }
    let(:user) { build(:user) }
    let(:amount) { account.balance }

    it "decreases the Account balance by the Income amount" do
      expect { command }.to change(account, :balance).by(-income.amount)
    end

    context "when Income amount is greater than Account balance" do
      let(:amount) { account.balance + Money.from_amount(1, account.currency) }

      it "raises Account::NotEnoughBalance error" do
        expect { command }.to raise_error(Account::NotEnoughBalance)
      end

      it "does not decrease the Account balance" do
        expect { suppress(Account::NotEnoughBalance) { command } }.not_to change(account, :balance)
      end
    end
  end

  describe "Associations" do
    let(:income_category) { build(:income_category) }
    let(:account) { build(:account) }
    let(:expense_category) { build(:expense_category) }

    describe "#source" do
      it "can be only an IncomeCategory" do
        expect(build(:income, source: income_category)).to be_valid
        expect(build(:income, source: account)).not_to be_valid
        expect(build(:income, source: expense_category)).not_to be_valid
      end
    end

    describe "#destination" do
      it "can be only an Account" do
        expect(build(:income, destination: account)).to be_valid
        expect(build(:income, destination: income_category)).not_to be_valid
        expect(build(:income, destination: expense_category)).not_to be_valid
      end
    end

    describe "#category" do
      subject { income.category }

      it { is_expected.to be_an_instance_of(IncomeCategory) }
    end

    describe "#account" do
      subject { income.account }

      it { is_expected.to be_an_instance_of(Account) }
    end
  end
end
