class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[edit update destroy]

  decorates_assigned :transaction, :transactions

  def index
    @transactions =
      current_user.transactions.order(committed_date: :desc, created_at: :desc).includes(:source, :destination)
  end

  def new
    @transaction = current_user.transactions.new(type: params[:type])
  end

  def edit
  end

  def create
    @transaction = current_user.transactions.new(transaction_create_params)

    if @transaction.save
      redirect_to transactions_path, notice: t(".success")
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @transaction.update(transaction_update_params)
      respond_to do |format|
        format.html { redirect_to transactions_path, notice: t(".success") }
        format.turbo_stream { flash.now[:notice] = t(".success") }
      end
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @transaction.destroy!
    respond_to do |format|
      format.html { redirect_to transactions_path, notice: t(".success") }
      format.turbo_stream { flash.now[:notice] = t(".success") }
    end
  end

  private

  def set_transaction
    @transaction = current_user.transactions.find(params[:id])
  end

  def transaction_create_params
    params.require(:transaction).permit(%i[type source_id destination_id amount committed_date comment])
  end

  def transaction_update_params
    params.require(:transaction).permit(%i[source_id destination_id amount committed_date comment])
  end
end
