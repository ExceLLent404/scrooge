require "rails_helper"

RSpec.describe ApplicationDecorator do
  subject(:decorated_object) { object.decorate }

  describe "#to_partial_path" do
    subject { decorated_object.to_partial_path }

    context "when decorated object is an Account" do
      let(:object) { build(:account) }

      it { is_expected.to eql("accounts/account") }
    end

    context "when decorated object is an IncomeCategory" do
      let(:object) { build(:income_category) }

      it { is_expected.to eql("categories/category") }
    end

    context "when decorated object is an ExpenseCategory" do
      let(:object) { build(:expense_category) }

      it { is_expected.to eql("categories/category") }
    end

    context "when decorated object is an Income" do
      let(:object) { build(:income) }

      it { is_expected.to eql("transactions/transaction") }
    end

    context "when decorated object is an Expense" do
      let(:object) { build(:expense) }

      it { is_expected.to eql("transactions/transaction") }
    end
  end
end
