class TransactionsController < ApplicationController
  include Dry::Monads[:result]

  before_action :set_transaction, only: %i[show edit update destroy]

  decorates_assigned :transaction, :transactions

  def index
    transactions = current_user.transactions.order(committed_date: :desc, created_at: :desc)
    @pagy, @transactions = pagy_countless(transactions.includes(:source, :destination))

    render_index_view
  end

  def show
  end

  def new
    @transaction = current_user.transactions.new(type: params[:type])
  end

  def edit
  end

  def create
    @transaction = current_user.transactions.new(transaction_create_params)
    result = CreateTransaction.call(transaction: @transaction)

    case result
    in Success(_)
      redirect_to transactions_path, notice: t(".success")
    in Failure(Symbol, message)
      flash.now[:alert] = message if message.present?
      render :new, status: :unprocessable_content
    end
  end

  def update
    result = UpdateTransaction.call(transaction: @transaction, data: transaction_update_params)

    case result
    in Success()
      respond_to do |format|
        format.html { redirect_to transactions_path, notice: t(".success") }
        format.turbo_stream { flash.now[:notice] = t(".success") }
      end
    in Failure(Symbol, message)
      flash.now[:alert] = message if message.present?
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_content }
        format.turbo_stream
      end
    end
  end

  def destroy
    result = DeleteTransaction.call(transaction: @transaction)

    case result
    in Success()
      respond_to do |format|
        format.html { redirect_to transactions_path, notice: t(".success") }
        format.turbo_stream { flash.now[:notice] = t(".success") }
      end
    in Failure(Symbol, message)
      respond_to do |format|
        format.html { redirect_to transactions_path, alert: message }
        format.turbo_stream { flash.now[:alert] = message }
      end
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

  def render_index_view
    format = params[:format]&.to_sym || :html
    render "index", formats: [format]
  end
end
