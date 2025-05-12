class CategoriesController < ApplicationController
  before_action :set_category, only: %i[edit update destroy]

  decorates_assigned :category, :income_categories, :expense_categories

  def index
    @income_categories = current_user.income_categories.order(created_at: :asc)
    @expense_categories = current_user.expense_categories.order(created_at: :asc)
  end

  def new
    @category = Category.new(type: params[:type])
  end

  def edit
  end

  def create
    @category = current_user.categories.new(category_create_params)

    if @category.save
      respond_to do |format|
        format.html { redirect_to categories_path, notice: t(".success") }
        format.turbo_stream { flash.now[:notice] = t(".success") }
      end
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @category.update(category_update_params)
      respond_to do |format|
        format.html { redirect_to categories_path, notice: t(".success") }
        format.turbo_stream { flash.now[:notice] = t(".success") }
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

  def category_create_params
    params.require(:category).permit(:type, :name)
  end

  def category_update_params
    params.require(:category).permit(:name)
  end
end
