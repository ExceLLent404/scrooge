require "system_helper"

RSpec.describe "Accounts" do
  include_context "with authenticated user"

  describe "Viewing a list of accounts" do
    it "shows a list of accounts owned by user" do
      user_accounts = [create(:account, user:, balance_cents: 200), create(:account, user:, balance_cents: 404)]
      another_accounts = Array.new(2) { |n| create(:account, name: "Account #{n}", balance_cents: n + 100) }

      visit accounts_path

      user_accounts.each do |account|
        expect(page).to have_content(account.name).and have_content(account.balance_cents)
      end
      another_accounts.each { |account| expect(page).to have_no_content(account.name).and have_no_content(account.balance_cents) }
    end
  end

  describe "Creating a new account" do
    def act
      visit accounts_path

      click_on t("accounts.offer_new_account.text")

      fill_in "Name", with: name
      fill_in "Balance cents", with: balance unless default_balance

      click_on t("helpers.submit.create", model: Account)
    end

    let(:name) { attributes_for(:account)[:name] }
    let(:balance) { 100 }
    let(:default_balance) { false }

    it "creates a new user account" do
      act

      expect(success_notification).to have_content(t("accounts.create.success"))
      expect(page).to have_content(name).and have_content(balance)
    end

    it_behaves_like "validation of account name presence"
    it_behaves_like "validation of account balance presence"
    it_behaves_like "validation of account balance non-negativity"

    context "with suggested default balance" do
      let(:default_balance) { true }
      let(:balance) { 0 }

      it "creates an account with a zero balance" do
        act

        expect(page).to have_content(name).and have_content(balance)
      end
    end
  end

  describe "Editing an account" do
    def act
      visit accounts_path

      find_menu(account).hover
      click_on t("accounts.actions_menu.edit")

      fill_in "Name", with: name
      fill_in "Balance cents", with: balance

      click_on t("helpers.submit.update", model: Account)
    end

    let!(:account) { create(:account, user:) }
    let(:name) { "Updated #{account.name}" }
    let(:balance) { account.balance_cents + 1 }

    it "updates the account" do
      act

      expect(success_notification).to have_content(t("accounts.update.success"))
      expect(page).to have_content(name).and have_content(balance)
    end

    it_behaves_like "validation of account name presence"
    it_behaves_like "validation of account balance presence"
    it_behaves_like "validation of account balance non-negativity"
  end

  describe "Deleting an account" do
    it "deletes the account" do
      account = create(:account, user:)

      visit accounts_path

      find_menu(account).hover
      accept_confirm { click_on t("accounts.actions_menu.delete") }

      expect(success_notification).to have_content(t("accounts.destroy.success"))
      expect(page).to have_no_content(account.name).and have_no_content(account.balance_cents)
    end
  end

  describe "Canceling account deletion" do
    it "does not delete the account" do
      account = create(:account, user:)

      visit accounts_path

      find_menu(account).hover
      dismiss_confirm { click_on t("accounts.actions_menu.delete") }

      expect(page).to have_content(account.name).and have_content(account.balance_cents)
    end
  end
end
