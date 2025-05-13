require "rails_helper"

RSpec.describe "Categories requests" do
  include_context "with authenticated user"

  describe "GET /categories" do
    let(:request) { get categories_url }

    before do
      create(:income_category, user:)
      create(:expense_category, user:)
    end

    include_examples "of response status", :ok
    include_examples "of user authentication"
  end

  describe "GET /categories/:id" do
    let(:request) { get category_url(id) }
    let(:id) { create(:category, user:).id }

    include_examples "of response status", :ok
    include_examples "of user authentication"
    include_examples "of checking resource existence", :category
    include_examples "of checking resource ownership", :category
  end

  describe "GET /categories/new" do
    let(:request) { get new_category_url(type:) }
    let(:type) { %w[IncomeCategory ExpenseCategory].sample }

    include_examples "of response status", :ok
    include_examples "of user authentication"
  end

  describe "GET /categories/new/offer" do
    let(:request) { get offer_new_category_url(type:) }
    let(:type) { %w[IncomeCategory ExpenseCategory].sample }

    include_examples "of response status", :ok
    include_examples "of user authentication"
  end

  describe "GET /categories/:id/edit" do
    let(:request) { get edit_category_url(id) }
    let(:id) { create(:category, user:).id }

    include_examples "of response status", :ok
    include_examples "of user authentication"
    include_examples "of checking resource existence", :category
    include_examples "of checking resource ownership", :category
  end

  describe "POST /categories" do
    let(:request) { post categories_url, params: }
    let(:params) { {category: attributes_for(:category)} }

    include_examples "of redirection to list of", :categories
    include_examples "of user authentication"

    it "creates a new Category with the specified data and type" do
      expect { request }.to change { Category.find_by(params[:category]) }.from(nil).to(Category)
    end

    context "with invalid parameters" do
      let(:params) { {category: attributes_for(:category, :invalid)} }

      include_examples "of response status", :unprocessable_content

      it "does not create a new Category" do
        expect { request }.not_to change(Category, :count)
      end
    end
  end

  describe "PATCH /categories/:id" do
    let(:request) { patch category_url(id), params: }
    let(:id) { category.id }
    let(:category) { create(:category, user:) }
    let(:params) { {category: {name: "not #{category.name}"}} }

    include_examples "of redirection to list of", :categories
    include_examples "of user authentication"
    include_examples "of checking resource existence", :category
    include_examples "of checking resource ownership", :category

    it "updates the requested Category" do
      expect { request }.to change { category.reload.attributes }
    end

    context "with invalid parameters" do
      let(:params) { {category: attributes_for(:category, :invalid).except(:type)} }

      include_examples "of response status", :unprocessable_content

      it "does not update the requested Category" do
        expect { request }.not_to change { category.reload.attributes }
      end
    end
  end

  describe "DELETE /categories/:id" do
    let(:request) { delete category_url(id) }
    let(:id) { category.id }
    let(:category) { create(:category, user:) }

    include_examples "of redirection to list of", :categories
    include_examples "of user authentication"
    include_examples "of checking resource existence", :category
    include_examples "of checking resource ownership", :category

    it "deletes the requested Category" do
      expect { request }.to change { Category.find_by(id: category.id) }.from(category).to(nil)
    end

    it "deletes all related Transactions" do
      transaction = category.is_a?(IncomeCategory) ? create(:income, user:, source: category) : create(:expense, user:, destination: category)

      expect { request }.to change { Transaction.find_by(id: transaction.id) }.from(transaction).to(nil)
    end
  end
end
