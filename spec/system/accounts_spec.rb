require "system_helper"

RSpec.describe "Accounts" do
  include_context "with authenticated user"

  describe "Viewing a list of accounts" do
    it "shows a list of accounts owned by user" do
      user_accounts = [create(:account, user:, balance: 200), create(:account, user:, balance: 404)]
      another_accounts = Array.new(2) { |n| create(:account, name: "Account #{n}", balance: n + 1) }

      visit accounts_path

      user_accounts.each do |account|
        expect(page).to have_content(account.name).and have_content(account.balance)
      end
      another_accounts.each { |account| expect(page).to have_no_content(account.name).and have_no_content(account.balance) }
    end
  end

  describe "Creating a new account" do
    def act
      visit accounts_path

      click_on t("accounts.offer_new_account.text")

      fill_in "Name", with: name
      fill_in "Balance", with: balance unless default_balance

      click_on t("helpers.submit.create")
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

  describe "Canceling account creation" do
    let(:name) { "Canceling" }
    let(:balance) { 100500 }

    it "does not create an account and offers to do it" do
      visit accounts_path

      click_on t("accounts.offer_new_account.text")

      fill_in "Name", with: name
      fill_in "Balance", with: balance

      click_on t("shared.links.cancel")

      expect(page).to have_no_content(name).and have_no_content(balance)
      expect(page).to have_content(t("accounts.offer_new_account.text"))
    end
  end

  describe "Editing an account" do
    def act
      visit accounts_path

      find_menu(account).hover
      click_on t("shared.links.edit")

      fill_in "Name", with: name
      fill_in "Balance", with: balance

      click_on t("helpers.submit.update")
    end

    let!(:account) { create(:account, user:) }
    let(:name) { "Updated #{account.name}" }
    let(:balance) { account.balance + Money.from_amount(1) }

    it "updates the account" do
      act

      expect(success_notification).to have_content(t("accounts.update.success"))
      expect(page).to have_content(name).and have_content(balance)
    end

    it_behaves_like "validation of account name presence"
    it_behaves_like "validation of account balance presence"
    it_behaves_like "validation of account balance non-negativity"
  end

  describe "Canceling account edition" do
    let!(:account) { create(:account, user:) }
    let(:name) { "Canceling" }
    let(:balance) { 100500 }

    it "does not update the account and shows the original one" do
      visit accounts_path

      find_menu(account).hover
      click_on t("shared.links.edit")

      fill_in "Name", with: name
      fill_in "Balance", with: balance

      click_on t("shared.links.cancel")

      expect(page).to have_no_content(name).and have_no_content(balance)
      expect(page).to have_content(account.name).and have_content(account.balance)
    end
  end

  describe "Deleting an account" do
    it "deletes the account" do
      account = create(:account, user:)

      visit accounts_path

      find_menu(account).hover
      accept_confirm { click_on t("shared.links.delete") }

      expect(success_notification).to have_content(t("accounts.destroy.success"))
      expect(page).to have_no_content(account.name).and have_no_content(account.balance)
    end
  end

  describe "Canceling account deletion" do
    it "does not delete the account" do
      account = create(:account, user:)

      visit accounts_path

      find_menu(account).hover
      dismiss_confirm { click_on t("shared.links.delete") }

      expect(page).to have_content(account.name).and have_content(account.balance)
    end
  end
end
