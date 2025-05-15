require "system_helper"

RSpec.describe "Capital" do
  include_context "with authenticated user"

  describe "Viewing the Capital page" do
    let(:incomes) do
      create(:income, user:, committed_date: from.prev_day)
      [from, to].map { |date| create(:income, user:, committed_date: date) }
    end
    let(:expenses) do
      create(:expense, user:, committed_date: from.prev_day)
      [from, to].map { |date| create(:expense, user:, committed_date: date) }
    end
    let(:from) { Date.current.beginning_of_month }
    let(:to) { Date.current }

    it "shows the total amount of funds from all user accounts in the user's preferred currency" do
      accounts = Money::Currency.all.map { |currency| create(:account, user:, currency:) }
      amount = accounts.sum { |account| account.balance.exchange_to(user.preferred_currency) }

      visit capital_path

      expect(find(".card", text: t("capital.show.funds")))
        .to have_content(amount.format(symbol: false))
        .and have_content(user.preferred_currency.symbol)
    end

    it "shows the total amount of all incomes for the current month in the user's preferred currency" do
      amount = incomes.sum { |income| income.amount.exchange_to(user.preferred_currency) }

      visit capital_path

      expect(find(".card", text: t("capital.show.incomes")))
        .to have_content(amount.format(symbol: false))
        .and have_content(user.preferred_currency.symbol)
    end

    it "shows the total amount of all expenses for the current month in the user's preferred currency" do
      amount = expenses.sum { |expense| expense.amount.exchange_to(user.preferred_currency) }

      visit capital_path

      expect(find(".card", text: t("capital.show.expenses")))
        .to have_content(amount.format(symbol: false))
        .and have_content(user.preferred_currency.symbol)
    end
  end
end
