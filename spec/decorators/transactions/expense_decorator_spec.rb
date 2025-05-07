require "rails_helper"

RSpec.describe ExpenseDecorator do
  subject(:decorated_expense) { expense.decorate }

  let(:expense) { build(:expense) }

  describe "#color" do
    subject { decorated_expense.color }

    it { is_expected.to eql("danger") }
  end

  describe "#possible_sources" do
    subject { decorated_expense.possible_sources }

    it { is_expected.to be_an_instance_of(AccountsDecorator) }
  end

  describe "#possible_destinations" do
    subject { decorated_expense.possible_destinations }

    it { is_expected.to be_an_instance_of(ExpenseCategoriesDecorator) }
  end
end
