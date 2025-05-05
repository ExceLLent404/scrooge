require "rails_helper"

RSpec.describe ExpenseCategory do
  subject(:category) { build(:expense_category) }

  it { is_expected.to be_a(Category) }

  describe "#type" do
    it "can be only `ExpenseCategory`" do
      expect(category.type).to eql("ExpenseCategory")

      category.type = "IncomeCategory"
      expect(category).not_to be_valid
    end
  end
end
