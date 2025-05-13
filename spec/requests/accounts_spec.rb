require "rails_helper"

RSpec.describe "Accounts requests" do
  include_context "with authenticated user"

  describe "GET /accounts" do
    let(:request) { get accounts_url }

    before { create(:account, user:) }

    include_examples "of response status", :ok
    include_examples "of user authentication"
  end

  describe "GET /accounts/:id" do
    let(:request) { get account_url(id) }
    let(:id) { create(:account, user:).id }

    include_examples "of response status", :ok
    include_examples "of user authentication"
    include_examples "of checking resource existence", :account
    include_examples "of checking resource ownership", :account
  end

  describe "GET /accounts/new" do
    let(:request) { get new_account_url }

    include_examples "of response status", :ok
    include_examples "of user authentication"
  end

  describe "GET /accounts/new/offer" do
    let(:request) { get offer_new_account_url }

    include_examples "of response status", :ok
    include_examples "of user authentication"
  end

  describe "GET /accounts/:id/edit" do
    let(:request) { get edit_account_url(id) }
    let(:id) { create(:account, user:).id }

    include_examples "of response status", :ok
    include_examples "of user authentication"
    include_examples "of checking resource existence", :account
    include_examples "of checking resource ownership", :account
  end

  describe "POST /accounts" do
    let(:request) { post accounts_url, params: }
    let(:params) { {account: attributes_for(:account)} }
    let(:search_params) { params[:account].dup.tap { |hash| hash[:balance_cents] = balance_cents }.tap { |hash| hash.delete(:balance) } }
    let(:balance_cents) { Money.from_amount(params[:account][:balance]).cents }

    include_examples "of redirection to list of", :accounts
    include_examples "of user authentication"

    it "creates a new Account with the specified data" do
      expect { request }.to change { Account.find_by(search_params) }.from(nil).to(Account)
    end

    context "with invalid parameters" do
      let(:params) { {account: attributes_for(:account, :invalid)} }

      include_examples "of response status", :unprocessable_content

      it "does not create a new Account" do
        expect { request }.not_to change(Account, :count)
      end
    end
  end

  describe "PATCH /accounts/:id" do
    let(:request) { patch account_url(id), params: }
    let(:id) { account.id }
    let(:account) { create(:account, user:) }
    let(:params) { {account: {name: "not #{account.name}"}} }

    include_examples "of redirection to list of", :accounts
    include_examples "of user authentication"
    include_examples "of checking resource existence", :account
    include_examples "of checking resource ownership", :account

    it "updates the requested Account" do
      expect { request }.to change { account.reload.attributes }
    end

    context "with invalid parameters" do
      let(:params) { {account: attributes_for(:account, :invalid)} }

      include_examples "of response status", :unprocessable_content

      it "does not update the requested Account" do
        expect { request }.not_to change { account.reload.attributes }
      end
    end
  end

  describe "DELETE /accounts/:id" do
    let(:request) { delete account_url(id) }
    let(:id) { account.id }
    let(:account) { create(:account, user:) }

    include_examples "of redirection to list of", :accounts
    include_examples "of user authentication"
    include_examples "of checking resource existence", :account
    include_examples "of checking resource ownership", :account

    it "deletes the requested Account" do
      expect { request }.to change { Account.find_by(id: account.id) }.from(account).to(nil)
    end

    it "deletes all related Transactions" do
      income = create(:income, user:, destination: account)
      expense = create(:expense, user:, source: account)

      expect { request }
        .to change { [Income.find_by(id: income.id), Expense.find_by(id: expense.id)] }
        .from([income, expense])
        .to([nil, nil])
    end
  end
end
