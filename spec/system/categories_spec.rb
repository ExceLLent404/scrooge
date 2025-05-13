require "system_helper"

RSpec.describe "Categories" do
  include_context "with authenticated user"

  describe "Viewing a list of categories" do
    let!(:income_category) { create(:income_category, user:) }
    let!(:expense_category) { create(:expense_category, user:) }

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
  end

  describe "Creating a new category" do
    def act
      visit categories_path

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
    def act
      visit categories_path

      find_menu(category).hover
      click_on t("shared.links.edit")

      fill_in "Name", with: name

      click_on t("helpers.submit.update")
    end

    let(:type) { %i[income expense].sample }
    let!(:category) { create(:"#{type}_category", user:) }
    let(:name) { "Updated #{category.name}" }

    it "updates the category" do
      act

      expect(success_notification).to have_content(t("categories.update.success"))
      expect(page).to have_content(name)
    end

    it_behaves_like "validation of category name presence"
  end

  describe "Canceling category edition" do
    def act
      visit categories_path

      find_menu(category).hover
      click_on t("shared.links.edit")

      fill_in "Name", with: name

      click_on t("shared.links.cancel")
    end

    let(:type) { %i[income expense].sample }
    let!(:category) { create(:"#{type}_category", user:) }
    let(:name) { "Canceling" }

    it "does not update the category and shows the original one" do
      act

      expect(page).to have_no_content(name)
      expect(find(".block", text: "#{type.capitalize} categories")).to have_content(category.name)
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
end
