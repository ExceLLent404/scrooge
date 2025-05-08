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
