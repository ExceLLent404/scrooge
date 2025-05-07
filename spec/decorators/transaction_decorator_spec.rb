require "rails_helper"

RSpec.describe TransactionDecorator do
  subject(:decorated_transaction) { transaction.decorate }

  describe "#human_type" do
    subject { decorated_transaction.human_type }

    context "when Transaction is Income" do
      let(:transaction) { build(:income) }

      it { is_expected.to eql("income") }
    end

    context "when Transaction is Expense" do
      let(:transaction) { build(:expense) }

      it { is_expected.to eql("expense") }
    end
  end
end
