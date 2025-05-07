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
end
