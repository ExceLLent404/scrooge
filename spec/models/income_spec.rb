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
end
