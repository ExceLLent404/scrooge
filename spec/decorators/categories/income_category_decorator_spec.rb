require "rails_helper"

RSpec.describe IncomeCategoryDecorator do
  subject(:decorated_category) { category.decorate }

  let(:category) { build(:income_category) }

  describe "#color" do
    subject { decorated_category.color }

    it { is_expected.to eql("success") }
  end
end
