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
  end
end
