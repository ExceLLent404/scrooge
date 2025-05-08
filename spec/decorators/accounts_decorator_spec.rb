require "rails_helper"

RSpec.describe AccountsDecorator do
  subject(:decorated_accounts) { described_class.decorate(accounts) }

  let(:accounts) { build_pair(:account) }

  describe "#selection_prompt" do
    subject { decorated_accounts.selection_prompt }

    it { is_expected.to eql("Select account") }
  end
end
