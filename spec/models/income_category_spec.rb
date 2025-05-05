require "rails_helper"

RSpec.describe IncomeCategory do
  subject(:category) { build(:income_category) }

  it { is_expected.to be_a(Category) }

  describe "#type" do
    it "can be only `IncomeCategory`" do
      expect(category.type).to eql("IncomeCategory")

      category.type = "ExpenseCategory"
      expect(category).not_to be_valid
    end
  end
end
