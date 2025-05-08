require "rails_helper"

RSpec.describe CategoryDecorator do
  subject(:decorated_category) { category.decorate }

  let(:category) { build(:category) }

  describe "#human_type" do
    subject { decorated_category.human_type }

    context "when Category is IncomeCategory" do
      let(:category) { build(:income_category) }

      it { is_expected.to eql("income category") }
    end

    context "when Category is ExpenseCategory" do
      let(:category) { build(:expense_category) }

      it { is_expected.to eql("expense category") }
    end
  end

  describe "#name_text_weight" do
    subject { decorated_category.name_text_weight }

    it { is_expected.to eql("has-text-weight-semibold") }
  end
end
