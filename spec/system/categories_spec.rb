require "system_helper"

RSpec.describe "Categories" do
  include_context "with authenticated user"

  let(:accounting) { build(:accounting) }
  let(:currency) { Money::Currency.all.excluding(user.preferred_currency).sample }
  let(:from) { accounting.from }
  let(:to) { accounting.to }

  describe "Viewing a list of categories" do
    let!(:income_category) { create(:income_category, user:) }
    let!(:expense_category) { create(:expense_category, user:) }
    let(:incomes) do
      create(:income, user:, source: income_category, committed_date: from.prev_day)
      [from, to].map { |date| create(:income, user:, source: income_category, committed_date: date) }
    end

    it "shows categories owned by user divided into income and expense categories" do
      another_user_categories = %i[income expense].map do |type|
        create(:"#{type}_category", name: "Another user #{type} category")
      end

      visit categories_path

      income_categories = find(".block", text: "Income categories")
      expect(income_categories).to have_content(income_category.name)

      expense_categories = find(".block", text: "Expense categories")
      expect(expense_categories).to have_content(expense_category.name)

      another_user_categories.each { |category| expect(page).to have_no_content(category.name) }
    end

    context "by default" do
      let(:from) { Date.current.beginning_of_month }
      let(:to) { Date.current }

      it "shows the total amount of all transactions for each category for the current month in the user's preferred currency" do
        amount = incomes.sum { |income| income.amount.exchange_to(user.preferred_currency) }

        visit categories_path

        expect(find_object(income_category))
          .to have_content(amount.format(symbol: false))
          .and have_content(user.preferred_currency.symbol)

        expect(find_object(expense_category))
          .to have_content(0.to_money.format(symbol: false))
          .and have_content(user.preferred_currency.symbol)
      end
    end

    context "when specifying a currency and period of the committed date of the transactions" do
      def act
        visit categories_path

        select currency.symbol
        fill_in "From", with: from
        fill_in "To", with: to
      end

      it "shows the total amount of all transactions for each category for the specified period in the specified currency" do
        amount = incomes.sum { |income| income.amount.exchange_to(currency) }

        act

        expect(find_object(income_category))
          .to have_content(amount.format(symbol: false))
          .and have_content(currency.symbol)

        expect(find_object(expense_category))
          .to have_content(0.to_money.format(symbol: false))
          .and have_content(currency.symbol)
      end

      it_behaves_like "validation of 'From'-'To' period boundaries correctness"

      context "when the specified period is invalid" do
        let(:from) { Date.current }
        let(:to) { Date.yesterday }

        it "shows zero amount for each category in the specified currency" do
          create(:income, user:, source: income_category, committed_date: from)
          create(:expense, user:, destination: expense_category, committed_date: to)

          act

          expect(find_object(income_category))
            .to have_content(0.to_money.format(symbol: false))
            .and have_content(currency.symbol)

          expect(find_object(expense_category))
            .to have_content(0.to_money.format(symbol: false))
            .and have_content(currency.symbol)
        end
      end
    end
  end

  describe "Creating a new category" do
    def act(specify_currency: false)
      visit categories_path

      select currency.symbol if specify_currency

      click_on t("categories.offer_new_category.text", type: "#{type} category")

      fill_in "Name", with: name

      click_on t("helpers.submit.create")
    end

    let(:type) { %i[income expense].sample }
    let(:name) { attributes_for(:"#{type}_category")[:name] }

    it "creates a new category of the selected type" do
      act

      expect(success_notification).to have_content(t("categories.create.success"))
      expect(find(".block", text: "#{type.capitalize} categories")).to have_content(name)
    end

    it "shows zero transactions amount for created category in the specified currency" do
      act(specify_currency: true)

      expect(find(".card", text: name))
        .to have_content(0.to_money.format(symbol: false))
        .and have_content(currency.symbol)
    end

    it_behaves_like "validation of category name presence"
  end

  describe "Canceling category creation" do
    let(:type) { %i[income expense].sample }
    let(:name) { "Canceling" }

    it "does not create a category and offers to do it" do
      visit categories_path

      click_on t("categories.offer_new_category.text", type: "#{type} category")

      fill_in "Name", with: name

      click_on t("shared.links.cancel")

      expect(page).to have_no_content(name)
      expect(find(".block", text: "#{type.capitalize} categories"))
        .to have_content(t("categories.offer_new_category.text", type: "#{type} category"))
    end
  end

  describe "Editing a category" do
    def act(specify_currency_and_period: false)
      visit categories_path

      if specify_currency_and_period
        select currency.symbol
        fill_in "From", with: from
        fill_in "To", with: to
      end

      find_menu(category).hover
      click_on t("shared.links.edit")

      fill_in "Name", with: name

      click_on t("helpers.submit.update")
    end

    let(:type) { %i[income expense].sample }
    let!(:category) { create(:"#{type}_category", user:) }
    let(:name) { "Updated #{category.name}" }
    let(:source_or_destination) { (type == :income) ? :source : :destination }
    let(:transactions) do
      create(type, :user => user, source_or_destination => category, :committed_date => from.prev_day)
      [from, to].map { |date| create(type, :user => user, source_or_destination => category, :committed_date => date) }
    end

    it "updates the category" do
      act

      expect(success_notification).to have_content(t("categories.update.success"))
      expect(page).to have_content(name)
    end

    it "shows the total amount of all transactions for updated category for the specified period in the specified currency" do
      amount = transactions.sum { |transaction| transaction.amount.exchange_to(currency) }

      act(specify_currency_and_period: true)

      expect(find_object(category))
        .to have_content(amount.format(symbol: false))
        .and have_content(currency.symbol)
    end

    it_behaves_like "validation of category name presence"
  end

  describe "Canceling category edition" do
    def act(specify_currency_and_period: false)
      visit categories_path

      if specify_currency_and_period
        select currency.symbol
        fill_in "From", with: from
        fill_in "To", with: to
      end

      find_menu(category).hover
      click_on t("shared.links.edit")

      fill_in "Name", with: name

      click_on t("shared.links.cancel")
    end

    let(:type) { %i[income expense].sample }
    let!(:category) { create(:"#{type}_category", user:) }
    let(:name) { "Canceling" }
    let(:source_or_destination) { (type == :income) ? :source : :destination }
    let(:transactions) do
      create(type, :user => user, source_or_destination => category, :committed_date => from.prev_day)
      [from, to].map { |date| create(type, :user => user, source_or_destination => category, :committed_date => date) }
    end

    it "does not update the category and shows the original one" do
      act

      expect(page).to have_no_content(name)
      expect(find(".block", text: "#{type.capitalize} categories")).to have_content(category.name)
    end

    it "shows the total amount of all transactions for the category for the specified period in the specified currency" do
      amount = transactions.sum { |transaction| transaction.amount.exchange_to(currency) }

      act(specify_currency_and_period: true)

      expect(find_object(category))
        .to have_content(amount.format(symbol: false))
        .and have_content(currency.symbol)
    end
  end

  describe "Deleting a category" do
    it "deletes the category" do
      category = create(:category, user:)

      visit categories_path

      find_menu(category).hover
      accept_confirm { click_on t("shared.links.delete") }

      expect(success_notification).to have_content(t("categories.destroy.success"))
      expect(page).to have_no_content(category.name)
    end
  end

  describe "Canceling category deletion" do
    it "does not delete the category" do
      category = create(:category, user:)

      visit categories_path

      find_menu(category).hover
      dismiss_confirm { click_on t("shared.links.delete") }

      expect(page).to have_content(category.name)
    end
  end

  describe "Accounting parameters" do
    let(:type) { %i[income expense].sample }
    let!(:category) { create(:"#{type}_category", user:) }
    let(:source_or_destination) { (type == :income) ? :source : :destination }
    let(:transactions) do
      create(type, :user => user, source_or_destination => category, :committed_date => from.prev_day)
      [from, to].map { |date| create(type, :user => user, source_or_destination => category, :committed_date => date) }
    end

    it "are preserved during category manipulations" do
      amount = transactions.sum { |transaction| transaction.amount.exchange_to(currency) }

      visit categories_path
      select currency.symbol
      fill_in "From", with: from
      fill_in "To", with: to

      expect(find_object(category))
        .to have_content(amount.format(symbol: false))
        .and have_content(currency.symbol)

      # Create after cancellation
      click_on t("categories.offer_new_category.text", type: "#{type} category")
      click_on t("shared.links.cancel")
      click_on t("categories.offer_new_category.text", type: "#{type} category")
      name = "Created after cancellation"
      fill_in "Name", with: name
      click_on t("helpers.submit.create")
      expect(find(".card", text: name))
        .to have_content(0.to_money.format(symbol: false))
        .and have_content(currency.symbol)

      # Create yet another category
      click_on t("categories.offer_new_category.text", type: "#{type} category")
      name = "Yet another category"
      fill_in "Name", with: name
      click_on t("helpers.submit.create")
      expect(find(".card", text: name))
        .to have_content(0.to_money.format(symbol: false))
        .and have_content(currency.symbol)

      # Edit just created category
      find(".card", text: "Yet another category").find(".fa-ellipsis").hover
      click_on t("shared.links.edit")
      name = "Edited after creation"
      fill_in "Name", with: name
      click_on t("helpers.submit.update")
      expect(find(".card", text: name))
        .to have_content(0.to_money.format(symbol: false))
        .and have_content(currency.symbol)

      # Edit just edited category
      find(".card", text: "Edited after creation").find(".fa-ellipsis").hover
      click_on t("shared.links.edit")
      name = "Edited after edition"
      fill_in "Name", with: name
      click_on t("helpers.submit.update")
      expect(find(".card", text: name))
        .to have_content(0.to_money.format(symbol: false))
        .and have_content(currency.symbol)

      # Edit after cancellation
      find_menu(category).hover
      click_on t("shared.links.edit")
      click_on t("shared.links.cancel")
      find_menu(category).hover
      click_on t("shared.links.edit")
      name = "Edited after cancellation"
      fill_in "Name", with: name
      click_on t("helpers.submit.update")
      expect(find_object(category))
        .to have_content(amount.format(symbol: false))
        .and have_content(currency.symbol)
    end
  end
end
