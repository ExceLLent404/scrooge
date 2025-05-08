require "rails_helper"

RSpec.describe ExpenseCategoriesDecorator do
  subject(:decorated_categories) { described_class.decorate(categories) }

  let(:categories) { build_pair(:expense_category) }

  describe "#human_type" do
    subject { decorated_categories.human_type }

    it { is_expected.to eql("Expense categories") }
  end

  describe "#selection_prompt" do
    subject { decorated_categories.selection_prompt }

    it { is_expected.to eql("Select expense category") }
  end
end
