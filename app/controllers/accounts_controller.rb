class AccountsController < ApplicationController
  before_action :set_account, only: %i[edit update destroy]

  def index
    @accounts = current_user.accounts.order(created_at: :asc)
  end

  def new
    @account = Account.new
  end

  def edit
  end

  def create
    @account = current_user.accounts.new(account_params)

    if @account.save
      redirect_to accounts_path, notice: t(".success")
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @account.update(account_params)
      redirect_to accounts_path, notice: t(".success")
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @account.destroy!
    redirect_to accounts_path, notice: t(".success")
  end

  private

  def set_account
    @account = current_user.accounts.find(params[:id])
  end

  def account_params
    params.require(:account).permit(:name, :balance_cents)
  end
end
