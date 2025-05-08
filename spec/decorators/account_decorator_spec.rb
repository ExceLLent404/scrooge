require "rails_helper"

RSpec.describe AccountDecorator do
  subject(:decorated_account) { account.decorate }

  let(:account) { build(:account) }

  describe "#name_text_weight" do
    subject { decorated_account.name_text_weight }

    it { is_expected.to eql("has-text-weight-normal") }
  end

  describe "#to_label" do
    subject(:label) { decorated_account.to_label }

    it "returns account info including name and balance" do
      expect(label).to include(account.name).and include(account.balance.to_s)
    end
  end
end
