class CategoriesController < ApplicationController
  before_action :set_category, only: %i[show edit update destroy]
  before_action :set_accounting, except: :destroy

  decorates_assigned :category, :income_categories, :expense_categories, :accounting

  def index
    @income_categories = current_user.income_categories.order(created_at: :asc)
    @expense_categories = current_user.expense_categories.order(created_at: :asc)

    @transactions_amounts_by_categories =
      @accounting.transactions_amounts_by_categories(@income_categories + @expense_categories)
  end

  def show
    @transactions_amount = @accounting.transactions_amount_by_category(@category)
  end

  def new
    @category = Category.new(type: params[:type])
  end

  def offer
  end

  def edit
  end

  def create
    @category = current_user.categories.new(category_create_params)

    if @category.save
      respond_to do |format|
        format.html { redirect_to categories_path, notice: t(".success") }
        format.turbo_stream do
          flash.now[:notice] = t(".success")

          @transactions_amount = @accounting.transactions_amount_by_category(@category)
        end
      end
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @category.update(category_update_params)
      respond_to do |format|
        format.html { redirect_to categories_path, notice: t(".success") }
        format.turbo_stream do
          flash.now[:notice] = t(".success")

          @transactions_amount = @accounting.transactions_amount_by_category(@category)
        end
      end
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @category.destroy!

    respond_to do |format|
      format.html { redirect_to categories_path, notice: t(".success") }
      format.turbo_stream { flash.now[:notice] = t(".success") }
    end
  end

  private

  def set_category
    @category = current_user.categories.find(params[:id])
  end

  def set_accounting
    @accounting = Accounting.new(user: current_user, **accounting_params)
  end

  def accounting_params
    params[:accounting]&.permit(%i[currency from to]) || {}
  end

  def category_create_params
    params.require(:category).permit(:type, :name)
  end

  def category_update_params
    params.require(:category).permit(:name)
  end
end
