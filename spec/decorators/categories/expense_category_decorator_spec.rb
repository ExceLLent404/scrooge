require "rails_helper"

RSpec.describe ExpenseCategoryDecorator do
  subject(:decorated_category) { category.decorate }

  let(:category) { build(:expense_category) }

  describe "#color" do
    subject { decorated_category.color }

    it { is_expected.to eql("danger") }
  end
end
