require "rails_helper"

RSpec.describe AccountDecorator do
  subject(:decorated_account) { account.decorate }

  let(:account) { build(:account) }

  describe "#name_text_weight" do
    subject { decorated_account.name_text_weight }

    it { is_expected.to eql("has-text-weight-normal") }
  end
end
