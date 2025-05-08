require "rails_helper"

RSpec.describe IncomeCategoriesDecorator do
  subject(:decorated_categories) { described_class.decorate(categories) }

  let(:categories) { build_pair(:income_category) }

  describe "#human_type" do
    subject { decorated_categories.human_type }

    it { is_expected.to eql("Income categories") }
  end

  describe "#selection_prompt" do
    subject { decorated_categories.selection_prompt }

    it { is_expected.to eql("Select income category") }
  end
end
