require "rails_helper"

RSpec.describe "Transactions requests" do
  include_context "with authenticated user"

  describe "GET /transactions" do
    let(:request) { get transactions_url }

    before do
      create(:income, user:)
      create(:expense, user:)
      create(:transaction, user:)
    end

    include_examples "of response status", :ok
    include_examples "of user authentication"
  end

  describe "GET /transactions/new" do
    let(:request) { get new_transaction_url(type:) }
    let(:type) { %w[Income Expense].sample }

    include_examples "of response status", :ok
    include_examples "of user authentication"
  end

  describe "GET /transactions/:id/edit" do
    let(:request) { get edit_transaction_url(id) }
    let(:id) { create(:transaction, user:).id }

    include_examples "of response status", :ok
    include_examples "of user authentication"
  end

  describe "POST /transactions" do
    let(:request) { post transactions_url, params: {transaction: creation_attributes} }
    let(:creation_attributes) do
      attrs = transaction.attributes
      attrs["amount"] = transaction.amount.to_s
      attrs.except(*%w[id source_type destination_type amount_cents user_id created_at updated_at])
    end
    let(:transaction) { build(:transaction, user:) }
    let(:source_id) { transaction.source.tap(&:save!).id }
    let(:destination_id) { transaction.destination.tap(&:save!).id }

    before do
      transaction.source_id = source_id
      transaction.destination_id = destination_id
    end

    include_examples "of redirection to list of", :transactions
    include_examples "of user authentication"

    it "creates a new Transaction with the specified data and type" do
      search_attributes = transaction.attributes.except(*%w[id created_at updated_at])
      expect { request }.to change { Transaction.find_by(search_attributes) }.from(nil).to(Transaction)
    end

    context "with invalid parameters" do
      let(:transaction) { build(:transaction, :invalid, user:) }

      include_examples "of response status", :unprocessable_content

      it "does not create a new Transaction" do
        expect { request }.not_to change(Transaction, :count)
      end
    end
  end

  describe "PATCH /transactions/:id" do
    let(:request) { patch transaction_url(id), params: {transaction: attributes} }
    let(:id) { transaction.id }
    let(:transaction) { create(:transaction, user:) }
    let(:attributes) do
      {
        amount: transaction.amount + Money.from_amount(1),
        comment: "New #{transaction.comment}".strip,
        committed_date: transaction.committed_date.prev_day
      }
    end

    include_examples "of redirection to list of", :transactions
    include_examples "of user authentication"

    it "updates transaction data to the specified ones" do
      expect { request }.to change { transaction.reload.attributes }

      changed_attributes = transaction.attributes.symbolize_keys
      changed_attributes[:amount] = Money.from_cents(changed_attributes[:amount_cents])
      expect(changed_attributes).to include(attributes)
    end

    context "with invalid parameters" do
      let(:attributes) { attributes_for(:transaction, :invalid).except(:type) }

      include_examples "of response status", :unprocessable_content

      it "does not update the requested Transaction" do
        expect { request }.not_to change { transaction.reload.attributes }
      end
    end
  end

  describe "DELETE /transactions/:id" do
    let(:request) { delete transaction_url(id) }
    let(:id) { transaction.id }
    let(:transaction) { create(:transaction, user:) }

    include_examples "of redirection to list of", :transactions
    include_examples "of user authentication"

    it "deletes the requested Transaction" do
      expect { request }.to change { Transaction.find_by(id: transaction.id) }.from(transaction).to(nil)
    end
  end
end
