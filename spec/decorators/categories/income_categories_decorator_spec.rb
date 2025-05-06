require "rails_helper"

RSpec.describe IncomeCategoriesDecorator do
  subject(:decorated_categories) { described_class.decorate(categories) }

  let(:categories) { build_pair(:income_category) }

  describe "#human_type" do
    subject { decorated_categories.human_type }

    it { is_expected.to eql("Income categories") }
  end
end
