require "system_helper"

RSpec.describe "Transactions" do
  include_context "with authenticated user"

  describe "Viewing a list of transactions" do
    let(:today) { Date.current }
    let(:yesterday) { Date.yesterday }
    let(:two_days_ago) { today - 2.days }
    let(:a_year_ago) { today.prev_year }
    let!(:user_transactions) do
      {
        today => [create(:income, user:, committed_date: today)],
        yesterday => [create(:expense, user:, committed_date: yesterday)],
        two_days_ago => [
          create(:income, user:, committed_date: two_days_ago),
          create(:expense, user:, committed_date: two_days_ago)
        ],
        a_year_ago => [create(:income, user:, committed_date: a_year_ago)]
      }
    end
    let!(:another_transactions) do
      another_user = create(:user)
      another_accounts = Array.new(2) { |n| create(:account, user: another_user, name: "Account #{n}") }
      another_categories = %i[income expense].map do |type|
        create(:"#{type}_category", user: another_user, name: "Another user #{type} category")
      end

      [
        create(:income, source: another_categories.first, destination: another_accounts.first, amount: 9999),
        create(:expense, source: another_accounts.last, destination: another_categories.last, amount: 100500)
      ]
    end

    it "shows a list of user transactions, divided by committed date, from recent to oldest" do
      visit transactions_path

      # check ownership
      another_transactions.each do |transaction|
        expect(page)
          .to have_no_content(transaction.source.name)
          .and have_no_content(transaction.destination.name)
          .and have_no_content(transaction.amount)
      end

      # check grouping
      user_transactions.each do |date, transactions|
        transactions.each do |transaction|
          expect(find(".block", text: date.to_relative_in_words))
            .to have_content(transaction.source.name)
            .and have_content(transaction.destination.name)
            .and have_content(transaction.amount)
        end
      end

      # check order
      ordered_transactions = user_transactions.values.map(&:reverse).flatten
      expect(page.all(".is-relative").map { |element| element.text.squish })
        .to eql(ordered_transactions.map { |t| "#{t.source.name} #{t.destination.name} #{t.amount.format} #{t.comment}" }.map(&:strip))
    end
  end

  describe "Creating an income" do
    def act
      visit transactions_path

      click_on t("transactions.offer_new_transaction.text", type: "income")

      select income_category.name
      select account.name
      fill_in "Amount", with: amount
      fill_in "Committed date", with: committed_date unless default_committed_date
      fill_in "Comment", with: comment

      click_on t("helpers.submit.create")
    end

    let!(:income_category) { create(:income_category, user:) }
    let!(:account) { create(:account, user:) }
    let(:amount) { 100 }
    let(:committed_date) { Date.current }
    let(:comment) { "Test income" }
    let(:default_committed_date) { false }

    it "creates an income" do
      act

      expect(success_notification).to have_content(t("transactions.create.success"))
      expect(find(".block", text: committed_date.to_relative_in_words))
        .to have_content(income_category.name)
        .and have_content(account.name)
        .and have_content(amount)
    end

    it_behaves_like "validation of transaction amount presence"
    it_behaves_like "validation of transaction amount positivity"
    it_behaves_like "validation of transaction committed date presence"
    it_behaves_like "validation of transaction committed date occurrence"

    context "with suggested default committed date" do
      let(:default_committed_date) { true }

      it "creates an income with the current date" do
        act

        expect(find(".block", text: Date.current.to_relative_in_words))
          .to have_content(income_category.name)
          .and have_content(account.name)
          .and have_content(amount)
      end
    end
  end

  describe "Creating an expense" do
    def act
      visit transactions_path

      click_on t("transactions.offer_new_transaction.text", type: "expense")

      select account.name
      select expense_category.name
      fill_in "Amount", with: amount
      fill_in "Committed date", with: committed_date unless default_committed_date
      fill_in "Comment", with: comment

      click_on t("helpers.submit.create")
    end

    let!(:account) { create(:account, user:, balance:) }
    let(:balance) { 100 }
    let!(:expense_category) { create(:expense_category, user:) }
    let(:amount) { balance }
    let(:committed_date) { Date.current }
    let(:comment) { "Test expense" }
    let(:default_committed_date) { false }

    it "creates an expense" do
      act

      expect(success_notification).to have_content(t("transactions.create.success"))
      expect(find(".block", text: committed_date.to_relative_in_words))
        .to have_content(account.name)
        .and have_content(expense_category.name)
        .and have_content(amount)
    end

    it_behaves_like "validation of transaction amount presence"
    it_behaves_like "validation of transaction amount positivity"

    context "when amount is greater than account balance" do
      let(:amount) { balance + 1 }

      it "shows an error notification" do
        act

        expect(error_notification).to have_content(t(
          "errors.messages.account.not_enough_balance",
          name: account.name,
          balance: Money.from_amount(balance).format,
          amount: Money.from_amount(amount).format
        ))
      end
    end

    it_behaves_like "validation of transaction committed date presence"
    it_behaves_like "validation of transaction committed date occurrence"

    context "with suggested default committed date" do
      let(:default_committed_date) { true }

      it "creates an expense with the current date" do
        act

        expect(find(".block", text: Date.current.to_relative_in_words))
          .to have_content(account.name)
          .and have_content(expense_category.name)
          .and have_content(amount)
      end
    end
  end

  describe "Canceling transaction creation" do
    let(:type) { %i[income expense].sample }
    let!(:category) { create(:"#{type}_category", user:, name: "Cancellation category") }
    let!(:account) { create(:account, user:, name: "Cancellation account") }
    let(:amount) { 100500 }
    let(:comment) { "Cancellation comment" }

    it "does not create a transaction and offers to do it" do
      visit transactions_path

      click_on t("transactions.offer_new_transaction.text", type:)

      select category.name
      select account.name
      fill_in "Amount", with: amount
      fill_in "Comment", with: comment

      click_on t("shared.links.cancel")

      expect(page)
        .to have_no_content(category.name)
        .and have_no_content(account.name)
        .and have_no_content(amount)
        .and have_no_content(comment)
      expect(page).to have_content(t("transactions.offer_new_transaction.text", type:))
    end
  end

  describe "Editing an income" do
    def act
      visit transactions_path

      find_menu(income).hover
      click_on t("shared.links.edit")

      select income_category.name
      select account.name if account_change
      fill_in "Amount", with: amount
      fill_in "Comment", with: comment

      click_on t("helpers.submit.update")
    end

    let!(:income) { create(:income, user:, destination: current_account) }
    let(:current_account) { create(:account, user:, balance: current_account_balance) }
    let(:current_account_balance) { 100 }
    let!(:income_category) { create(:income_category, user:, name: "Not #{income.category.name}") }
    let(:amount) { income.amount + Money.from_amount(1) }
    let(:comment) { "Updated #{income.comment}" }
    let(:account_change) { false }

    it "updates the income" do
      act

      expect(success_notification).to have_content(t("transactions.update.success"))
      expect(find(".block", text: income.committed_date.to_relative_in_words))
        .to have_content(income_category.name)
        .and have_content(amount)
    end

    it_behaves_like "validation of transaction amount presence"
    it_behaves_like "validation of transaction amount positivity"

    context "when amount decreases" do
      let(:amount) { income.amount - Money.from_amount(1) }

      context "when the difference between the new and current amounts is greater than account balance" do
        let(:current_account_balance) { 0 }

        it "shows an error notification" do
          act

          expect(error_notification).to have_content(t(
            "errors.messages.account.not_enough_balance",
            name: current_account.name,
            balance: current_account.balance.format,
            amount: Money.from_amount(1).format
          ))
        end
      end
    end

    context "when account changed" do
      let(:account_change) { true }
      let!(:account) { create(:account, user:, name: "Not #{income.account.name}") }

      it "updates the income account" do
        act

        expect(find(".block", text: income.committed_date.to_relative_in_words))
          .to have_content(account.name)
      end

      context "when amount is greater than balance of the original account" do
        let(:current_account_balance) { 0 }

        it "shows an error notification" do
          act

          expect(error_notification).to have_content(t(
            "errors.messages.account.not_enough_balance",
            name: current_account.name,
            balance: current_account.balance.format,
            amount: income.amount.format
          ))
        end
      end
    end
  end

  describe "Editing an expense" do
    def act
      visit transactions_path

      find_menu(expense).hover
      click_on t("shared.links.edit")

      select account.name if account_change
      select expense_category.name
      fill_in "Amount", with: amount
      fill_in "Comment", with: comment

      click_on t("helpers.submit.update")
    end

    let!(:expense) { create(:expense, user:, source: current_account) }
    let(:current_account) { create(:account, user:, balance: current_account_balance) }
    let(:current_account_balance) { 100 }
    let!(:expense_category) { create(:expense_category, user:, name: "Not #{expense.category.name}") }
    let(:amount) { expense.amount - Money.from_amount(1) }
    let(:comment) { "Updated #{expense.comment}" }
    let(:account_change) { false }

    it "updates the expense" do
      act

      expect(success_notification).to have_content(t("transactions.update.success"))
      expect(find(".block", text: expense.committed_date.to_relative_in_words))
        .to have_content(expense_category.name)
        .and have_content(amount)
    end

    it_behaves_like "validation of transaction amount presence"
    it_behaves_like "validation of transaction amount positivity"

    context "when amount increases" do
      let(:amount) { expense.amount + Money.from_amount(1) }

      context "when the difference between the new and current amounts is greater than account balance" do
        let(:current_account_balance) { 0 }

        it "shows an error notification" do
          act

          expect(error_notification).to have_content(t(
            "errors.messages.account.not_enough_balance",
            name: current_account.name,
            balance: current_account.balance.format,
            amount: Money.from_amount(1).format
          ))
        end
      end
    end

    context "when account changed" do
      let(:account_change) { true }
      let!(:account) { create(:account, user:, name: "Not #{expense.account.name}", balance:) }
      let(:balance) { expense.amount }

      it "updates the expense account" do
        act

        expect(find(".block", text: expense.committed_date.to_relative_in_words))
          .to have_content(account.name)
      end

      context "when amount is greater than balance of the specified account" do
        let(:balance) { 0 }

        it "shows an error notification" do
          act

          expect(error_notification).to have_content(t(
            "errors.messages.account.not_enough_balance",
            name: account.name,
            balance: Money.from_amount(balance).format,
            amount: amount.format
          ))
        end
      end
    end
  end

  describe "Changing transaction committed date" do
    before { create(:transaction, user:, committed_date: prev_day) }

    def act
      visit transactions_path

      find_menu(transaction).hover
      click_on t("shared.links.edit")

      fill_in "Committed date", with: committed_date

      click_on t("helpers.submit.update")
    end

    let!(:transaction) { create(:transaction, user:) }
    let(:prev_day) { transaction.committed_date.prev_day }
    let(:committed_date) { prev_day }

    it "updates the transaction committed date and transaction display location" do
      act

      expect(success_notification).to have_content(t("transactions.update.success"))
      expect(find(".block", text: committed_date.to_relative_in_words))
        .to have_content(transaction.account.name)
        .and have_content(transaction.category.name)
        .and have_content(transaction.amount)
    end

    context "when there are other transactions with the same committed date" do
      before { create(:transaction, user:, committed_date: transaction.committed_date) }

      it "leaves a block of transactions corresponding to the previous transaction committed date" do
        act

        expect(page).to have_content(transaction.committed_date.to_relative_in_words)
      end
    end

    context "when there are no other transactions with the same committed date" do
      it "removes a block of transactions corresponding to the previous transaction committed date" do
        act

        expect(page).to have_no_content(transaction.committed_date.to_relative_in_words)
      end
    end

    it_behaves_like "validation of transaction committed date presence"
    it_behaves_like "validation of transaction committed date occurrence"
  end

  describe "Canceling transaction edition" do
    let!(:transaction) { create(:transaction, user:) }
    let(:amount) { 100500 }
    let(:comment) { "Cancellation comment" }

    it "does not update the transaction and shows the original one" do
      visit transactions_path

      find_menu(transaction).hover
      click_on t("shared.links.edit")

      fill_in "Amount", with: amount
      fill_in "Comment", with: comment

      click_on t("shared.links.cancel")

      expect(page).to have_no_content(amount).and have_no_content(comment)
      expect(page)
        .to have_content(transaction.category.name)
        .and have_content(transaction.account.name)
        .and have_content(transaction.amount)
    end
  end

  describe "Deleting a transaction" do
    before { transaction.account.update!(balance: transaction.amount) if transaction.is_a?(Income) }

    def act
      visit transactions_path

      find_menu(transaction).hover
      accept_confirm { click_on t("shared.links.delete") }
    end

    let!(:transaction) { create(:transaction, user:) }

    it "deletes the transaction" do
      act

      expect(success_notification).to have_content(t("transactions.destroy.success"))
      expect(page)
        .to have_no_content(transaction.source.name)
        .and have_no_content(transaction.destination.name)
        .and have_no_content(transaction.amount)
    end

    context "when there are other transactions with the same committed date" do
      before { create(:transaction, user:, committed_date: transaction.committed_date) }

      it "leaves a block of transactions corresponding to the previous transaction committed date" do
        act

        expect(page).to have_content(transaction.committed_date.to_relative_in_words)
      end
    end

    context "when there are no other transactions with the same committed date" do
      it "removes a block of transactions corresponding to the previous transaction committed date" do
        act

        expect(page).to have_no_content(transaction.committed_date.to_relative_in_words)
      end
    end

    context "when transaction is income" do
      let!(:transaction) { create(:income, user:) }
      let(:account) { transaction.account }

      context "when income amount is greater than account balance" do
        before { transaction.update!(amount: account.balance + Money.from_amount(1)) }

        it "shows an error notification" do
          act

          expect(error_notification).to have_content(t(
            "errors.messages.account.not_enough_balance",
            name: account.name,
            balance: account.balance.format,
            amount: transaction.amount.format
          ))
        end
      end
    end
  end

  describe "Canceling transaction deletion" do
    it "does not delete the transaction" do
      transaction = create(:transaction, user:)

      visit transactions_path

      find_menu(transaction).hover
      dismiss_confirm { click_on t("shared.links.delete") }

      expect(find(".block", text: transaction.committed_date.to_relative_in_words))
        .to have_content(transaction.source.name)
        .and have_content(transaction.destination.name)
        .and have_content(transaction.amount)
    end
  end
end
