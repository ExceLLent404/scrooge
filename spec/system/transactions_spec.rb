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
      fill_in "Committed date", with: committed_date
      fill_in "Comment", with: comment

      click_on t("helpers.submit.create")
    end

    let!(:income_category) { create(:income_category, user:) }
    let!(:account) { create(:account, user:) }
    let(:amount) { 100 }
    let(:committed_date) { Date.current }
    let(:comment) { "Test income" }

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
  end

  describe "Creating an expense" do
    def act
      visit transactions_path

      click_on t("transactions.offer_new_transaction.text", type: "expense")

      select account.name
      select expense_category.name
      fill_in "Amount", with: amount
      fill_in "Committed date", with: committed_date
      fill_in "Comment", with: comment

      click_on t("helpers.submit.create")
    end

    let!(:account) { create(:account, user:) }
    let!(:expense_category) { create(:expense_category, user:) }
    let(:amount) { 100 }
    let(:committed_date) { Date.current }
    let(:comment) { "Test expense" }

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
    it_behaves_like "validation of transaction committed date presence"
  end

  describe "Editing an income" do
    def act
      visit transactions_path

      find_menu(income).hover
      click_on t("shared.links.edit")

      select income_category.name
      select account.name
      fill_in "Amount", with: amount
      fill_in "Committed date", with: committed_date
      fill_in "Comment", with: comment

      click_on t("helpers.submit.update")
    end

    let!(:income) { create(:income, user:) }
    let!(:income_category) { create(:income_category, user:, name: "Not #{income.source.name}") }
    let!(:account) { create(:account, user:, name: "Not #{income.destination.name}") }
    let(:amount) { income.amount + Money.from_amount(1) }
    let(:committed_date) { income.committed_date.prev_day }
    let(:comment) { "Updated #{income.comment}" }

    it "updates the income" do
      act

      expect(success_notification).to have_content(t("transactions.update.success"))
      expect(find(".block", text: committed_date.to_relative_in_words))
        .to have_content(income_category.name)
        .and have_content(account.name)
        .and have_content(amount)
    end

    it_behaves_like "validation of transaction amount presence"
    it_behaves_like "validation of transaction amount positivity"
    it_behaves_like "validation of transaction committed date presence"
  end

  describe "Editing an expense" do
    def act
      visit transactions_path

      find_menu(expense).hover
      click_on t("shared.links.edit")

      select account.name
      select expense_category.name
      fill_in "Amount", with: amount
      fill_in "Committed date", with: committed_date
      fill_in "Comment", with: comment

      click_on t("helpers.submit.update")
    end

    let!(:expense) { create(:expense, user:) }
    let!(:account) { create(:account, user:, name: "Not #{expense.source.name}") }
    let!(:expense_category) { create(:expense_category, user:, name: "Not #{expense.destination.name}") }
    let(:amount) { expense.amount - Money.from_amount(1) }
    let(:committed_date) { expense.committed_date.prev_day }
    let(:comment) { "Updated #{expense.comment}" }

    it "updates the expense" do
      act

      expect(success_notification).to have_content(t("transactions.update.success"))
      expect(find(".block", text: committed_date.to_relative_in_words))
        .to have_content(account.name)
        .and have_content(expense_category.name)
        .and have_content(amount)
    end

    it_behaves_like "validation of transaction amount presence"
    it_behaves_like "validation of transaction amount positivity"
    it_behaves_like "validation of transaction committed date presence"
  end

  describe "Deleting a transaction" do
    it "deletes the transaction" do
      transaction = create(:transaction, user:)

      visit transactions_path

      find_menu(transaction).hover
      accept_confirm { click_on t("shared.links.delete") }

      expect(success_notification).to have_content(t("transactions.destroy.success"))
      expect(page)
        .to have_no_content(transaction.source.name)
        .and have_no_content(transaction.destination.name)
        .and have_no_content(transaction.amount)
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
