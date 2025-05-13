class AccountsController < ApplicationController
  before_action :set_account, only: %i[show edit update destroy]

  decorates_assigned :account, :accounts

  def index
    @accounts = current_user.accounts.order(created_at: :asc)
  end

  def show
  end

  def new
    @account = Account.new
  end

  def offer
  end

  def edit
  end

  def create
    @account = current_user.accounts.new(account_params)

    if @account.save
      respond_to do |format|
        format.html { redirect_to accounts_path, notice: t(".success") }
        format.turbo_stream { flash.now[:notice] = t(".success") }
      end
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @account.update(account_params)
      respond_to do |format|
        format.html { redirect_to accounts_path, notice: t(".success") }
        format.turbo_stream { flash.now[:notice] = t(".success") }
      end
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @account.destroy!

    respond_to do |format|
      format.html { redirect_to accounts_path, notice: t(".success") }
      format.turbo_stream { flash.now[:notice] = t(".success") }
    end
  end

  private

  def set_account
    @account = current_user.accounts.find(params[:id])
  end

  def account_params
    params.require(:account).permit(:name, :balance)
  end
end
