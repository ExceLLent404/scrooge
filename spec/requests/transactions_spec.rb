require "rails_helper"

RSpec.shared_examples "of failed updating" do
  include_examples "of response status", :unprocessable_content

  it "does not update the requested Transaction" do
    expect { request }.not_to change { transaction.reload.attributes }
  end
end

RSpec.shared_examples "of no changes to accounts when updating" do
  it "does not change the Account to the specified one" do
    expect { request }.not_to change { transaction.reload.account }
  end

  it "does not change the balance of the Accounts" do
    current_account_balance = transaction.account.balance
    new_account_balance = new_account.balance
    request
    expect(transaction.account.reload.balance).to eql(current_account_balance)
    expect(new_account.reload.balance).to eql(new_account_balance)
  end
end

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

  describe "GET /transactions/:id" do
    let(:request) { get transaction_url(id) }
    let(:id) { create(:transaction, user:).id }

    include_examples "of response status", :ok
    include_examples "of user authentication"
    include_examples "of checking resource existence", :transaction
    include_examples "of checking resource ownership", :transaction
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
    include_examples "of checking resource existence", :transaction
    include_examples "of checking resource ownership", :transaction
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
      transaction.account.deposit(transaction.amount)
      transaction.source_id = source_id
      transaction.destination_id = destination_id
    end

    include_examples "of redirection to list of", :transactions
    include_examples "of user authentication"

    it "creates a new Transaction with the specified data and type" do
      search_attributes = transaction.attributes.except(*%w[id created_at updated_at])
      expect { request }.to change { Transaction.find_by(search_attributes) }.from(nil).to(Transaction)
    end

    context "when Transaction is Income" do
      let(:transaction) { build(:income, user:) }

      it "increases the Account balance by the Income amount" do
        expect { request }.to change { transaction.account.reload.balance }.by(transaction.amount)
      end

      include_examples "of checking associated resource existence", :income_category, :source_id
      include_examples "of checking associated resource ownership", :income_category, :source_id
      include_examples "of checking associated resource existence", :account, :destination_id
      include_examples "of checking associated resource ownership", :account, :destination_id

      context "when both IncomeCategory and Account with the specified source_id and destination_id respectively belongs to another User" do
        let(:source_id) { create(:income_category, user: another_user).id }
        let(:destination_id) { create(:account, user: another_user).id }
        let(:another_user) { create(:user) }

        include_examples "of response status", :unprocessable_content
      end
    end

    context "when Transaction is Expense" do
      let(:transaction) { build(:expense, user:) }

      it "decreases the Account balance by the Expense amount" do
        expect { request }.to change { transaction.account.reload.balance }.by(-transaction.amount)
      end

      context "when Expense amount is greater than Account balance" do
        before { transaction.amount = transaction.account.balance + Money.from_amount(1) }

        include_examples "of response status", :unprocessable_content

        it "does not create a new Transaction" do
          expect { request }.not_to change(Transaction, :count)
        end

        it "does not decrease the Account balance" do
          expect { request }.not_to change { transaction.account.reload.balance }
        end
      end

      include_examples "of checking associated resource existence", :account, :source_id
      include_examples "of checking associated resource ownership", :account, :source_id
      include_examples "of checking associated resource existence", :expense_category, :destination_id
      include_examples "of checking associated resource ownership", :expense_category, :destination_id

      context "when both Account and ExpenseCategory with the specified source_id and destination_id respectively belongs to another User" do
        let(:source_id) { create(:account, user: another_user, balance: transaction.amount).id }
        let(:destination_id) { create(:expense_category, user: another_user).id }
        let(:another_user) { create(:user) }

        include_examples "of response status", :unprocessable_content
      end
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
    let(:transaction) { build(type, user:) }
    let(:type) { :transaction }
    let(:attributes) do
      {
        amount: transaction.amount + Money.from_amount(1),
        comment: "New #{transaction.comment}".strip,
        committed_date: transaction.committed_date.prev_day
      }
    end

    before do
      balance = 1
      transaction.account.balance = balance
      maximum_negative_diff = balance + 1
      transaction.amount = rand(maximum_negative_diff..balance * 100.0).round(2)
      transaction.save!
    end

    include_examples "of redirection to list of", :transactions
    include_examples "of user authentication"
    include_examples "of checking resource existence", :transaction
    include_examples "of checking resource ownership", :transaction

    it "updates transaction data to the specified ones" do
      expect { request }.to change { transaction.reload.attributes }

      changed_attributes = transaction.attributes.symbolize_keys
      changed_attributes[:amount] = Money.from_cents(changed_attributes[:amount_cents])
      expect(changed_attributes).to include(attributes)
    end

    context "when Transaction is Income" do
      let(:type) { :income }

      context "when source_id is specified" do
        let(:attributes) { {source_id:} }

        context "when the specified source_id belongs to another IncomeCategory of the User" do
          let(:source_id) { another_category.id }
          let(:another_category) { create(:income_category, user:) }

          it "changes the IncomeCategory to the specified one" do
            expect { request }.to change { transaction.reload.source }.to(another_category)
          end
        end

        include_examples "of checking associated resource existence", :income_category, :source_id
        include_examples "of checking associated resource ownership", :income_category, :source_id
      end

      context "when amount is specified" do
        let(:attributes) { {amount: transaction.amount + diff} }

        context "when the new Income amount is greater than the current one" do
          let(:diff) { Money.from_amount(1) }

          it "increases the Account balance by the difference between the new and current amounts" do
            expect { request }.to change { transaction.account.reload.balance }.by(diff)
          end
        end

        context "when the new Income amount is less than the current one" do
          let(:diff) { Money.from_amount(-1) }

          it "decreases the Account balance by the difference between the new and current amounts" do
            expect { request }.to change { transaction.account.reload.balance }.by(diff)
          end

          context "when the difference between the new and current amounts is greater than Account balance" do
            let(:diff) { -(transaction.account.balance + Money.from_amount(1)) }

            include_examples "of failed updating"

            it "does not decrease the Account balance" do
              expect { request }.not_to change { transaction.account.reload.balance }
            end
          end
        end
      end

      context "when destination_id is specified" do
        let(:attributes) { {destination_id:} }

        context "when the specified destination_id belongs to another Account of the User" do
          let(:destination_id) { new_account.id }
          let(:new_account) { create(:account, user:) }
          let(:need_a_lot_of_money) { true }

          before { transaction.account.update!(balance: transaction.amount) if need_a_lot_of_money }

          it "changes the Account to the specified one" do
            expect { request }.to change { transaction.reload.account }.to(new_account)
          end

          it "decreases the balance of the current Account by the current Transaction amount" do
            current_account = transaction.account
            current_amount = transaction.amount
            expect { request }.to change { current_account.reload.balance }.by(-current_amount)
          end

          context "when new Transaction amount is not specified" do
            it "increases the balance of the new Account by the current Transaction amount" do
              expect { request }.to change { new_account.reload.balance }.by(transaction.amount)
            end
          end

          context "when new Transaction amount is specified" do
            let(:attributes) { {amount: new_amount, destination_id: new_account.id} }
            let(:new_amount) { Money.from_amount(attributes_for(:transaction)[:amount]) }

            it "increases the balance of the new Account by the new Transaction amount" do
              expect { request }.to change { new_account.reload.balance }.by(new_amount)
            end
          end

          context "when the current Transaction amount is greater than the balance of the current Account" do
            let(:need_a_lot_of_money) { false }

            include_examples "of failed updating"
            include_examples "of no changes to accounts when updating"
          end
        end

        include_examples "of checking associated resource existence", :account, :destination_id
        include_examples "of checking associated resource ownership", :account, :destination_id
      end

      context "when both IncomeCategory and Account with the specified source_id and destination_id respectively belongs to another User" do
        let(:attributes) { {source_id:, destination_id:} }
        let(:source_id) { create(:income_category, user: another_user).id }
        let(:destination_id) { create(:account, user: another_user).id }
        let(:another_user) { create(:user) }

        before { transaction.account.update!(balance: transaction.amount) }

        include_examples "of response status", :unprocessable_content
      end
    end

    context "when Transaction is Expense" do
      let(:type) { :expense }

      context "when destination_id is specified" do
        let(:attributes) { {destination_id:} }

        context "when the specified destination_id belongs to another ExpenseCategory of the User" do
          let(:destination_id) { another_category.id }
          let(:another_category) { create(:expense_category, user:) }

          it "changes the ExpenseCategory to the specified one" do
            expect { request }.to change { transaction.reload.destination }.to(another_category)
          end
        end

        include_examples "of checking associated resource existence", :expense_category, :destination_id
        include_examples "of checking associated resource ownership", :expense_category, :destination_id
      end

      context "when amount is specified" do
        let(:attributes) { {amount: transaction.amount + diff} }

        context "when the new Expense amount is greater than the current one" do
          let(:diff) { Money.from_amount(1) }

          it "decreases the Account balance by the difference between the new and current amounts" do
            expect { request }.to change { transaction.account.reload.balance }.by(-diff)
          end

          context "when the difference between the new and current amounts is greater than Account balance" do
            let(:diff) { transaction.account.balance + Money.from_amount(1) }

            include_examples "of failed updating"

            it "does not decrease the Account balance" do
              expect { request }.not_to change { transaction.account.reload.balance }
            end
          end
        end

        context "when the new Expense amount is less than the current one" do
          let(:diff) { Money.from_amount(-1) }

          it "increases the Account balance by the difference between the new and current amounts" do
            expect { request }.to change { transaction.account.reload.balance }.by(-diff)
          end
        end
      end

      context "when source_id is specified" do
        let(:attributes) { {source_id:} }

        context "when the specified source_id belongs to another Account of the User" do
          let(:source_id) { new_account.id }
          let(:new_account) { create(:account, user:, balance: transaction.amount) }

          it "changes the Account to the specified one" do
            expect { request }.to change { transaction.reload.account }.to(new_account)
          end

          it "increases the balance of the current Account by the current Transaction amount" do
            current_account = transaction.account
            current_amount = transaction.amount
            expect { request }.to change { current_account.reload.balance }.by(current_amount)
          end

          context "when new Transaction amount is not specified" do
            it "decreases the balance of the new Account by the current Transaction amount" do
              expect { request }.to change { new_account.reload.balance }.by(-transaction.amount)
            end

            context "when the current Transaction amount is greater than the balance of the new Account" do
              let(:new_account) { create(:account, user:, balance: 0) }

              include_examples "of failed updating"
              include_examples "of no changes to accounts when updating"
            end
          end

          context "when new Transaction amount is specified" do
            let(:attributes) { {amount: new_amount, source_id: new_account.id} }
            let(:new_amount) { Money.from_amount(attributes_for(:transaction)[:amount]) }
            let(:new_account) { create(:account, user:, balance: 1000) }

            it "decreases the balance of the new Account by the new Transaction amount" do
              expect { request }.to change { new_account.reload.balance }.by(-new_amount)
            end

            context "when the new Transaction amount is greater than the balance of the new Account" do
              let(:new_amount) { new_account.balance + Money.from_amount(1) }

              include_examples "of failed updating"
              include_examples "of no changes to accounts when updating"
            end
          end
        end

        include_examples "of checking associated resource existence", :account, :source_id
        include_examples "of checking associated resource ownership", :account, :source_id
      end

      context "when both Account and ExpenseCategory with the specified source_id and destination_id respectively belongs to another User" do
        let(:attributes) { {source_id:, destination_id:} }
        let(:source_id) { create(:account, user: another_user, balance: transaction.amount).id }
        let(:destination_id) { create(:expense_category, user: another_user).id }
        let(:another_user) { create(:user) }

        include_examples "of response status", :unprocessable_content
      end
    end

    context "with invalid parameters" do
      let(:attributes) { attributes_for(:transaction, :invalid).except(:type) }

      include_examples "of failed updating"
    end
  end

  describe "DELETE /transactions/:id" do
    let(:request) { delete transaction_url(id) }
    let(:id) { transaction.id }
    let(:transaction) { create(:transaction, user:) }

    before { transaction.account.update!(balance: 100) }

    include_examples "of redirection to list of", :transactions
    include_examples "of user authentication"
    include_examples "of checking resource existence", :transaction
    include_examples "of checking resource ownership", :transaction

    it "deletes the requested Transaction" do
      expect { request }.to change { Transaction.find_by(id: transaction.id) }.from(transaction).to(nil)
    end

    context "when Transaction is Income" do
      let(:transaction) { create(:income, user:, destination: account, amount:) }
      let(:account) { create(:account, user:, balance: 100) }
      let(:amount) { account.balance }

      it "decreases the Account balance by the Income amount" do
        expect { request }.to change { transaction.account.reload.balance }.by(-transaction.amount)
      end

      context "when Income amount is greater than Account balance" do
        let(:amount) { account.balance + Money.from_amount(1) }

        it "does not delete the requested Transaction" do
          expect { request }.not_to change { Transaction.find_by(id: transaction.id) }
        end

        it "does not decrease the Account balance" do
          expect { request }.not_to change { transaction.account.reload.balance }
        end
      end
    end

    context "when Transaction is Expense" do
      let(:transaction) { create(:expense, user:) }

      it "increases the Account balance by the Expense amount" do
        expect { request }.to change { transaction.account.reload.balance }.by(transaction.amount)
      end
    end
  end
end
