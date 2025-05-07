require "rails_helper"

RSpec.describe IncomeDecorator do
  subject(:decorated_income) { income.decorate }

  let(:income) { build(:income) }

  describe "#color" do
    subject { decorated_income.color }

    it { is_expected.to eql("success") }
  end

  describe "#possible_sources" do
    subject { decorated_income.possible_sources }

    it { is_expected.to be_an_instance_of(IncomeCategoriesDecorator) }
  end

  describe "#possible_destinations" do
    subject { decorated_income.possible_destinations }

    it { is_expected.to be_an_instance_of(AccountsDecorator) }
  end
end
