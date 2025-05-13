class UpdateTransaction < Operation
  option :transaction, reader: :private
  option :data, reader: :private

  option :cancel_transaction, default: -> { CancelTransaction }, reader: :private
  option :correct_transaction, default: -> { CorrectTransaction }, reader: :private
  option :perform_transaction, default: -> { PerformTransaction }, reader: :private

  def call
    ActiveRecord::Base.transaction do
      if same_account?
        yield correct_transaction.call(transaction:, new_amount:)
        yield update_transaction
      else
        yield cancel_transaction.call(transaction:)
        yield update_transaction
        yield perform_transaction.call(transaction:)
      end
    end

    Success()
  end

  private

  def same_account?
    account_id_key = transaction.is_a?(Income) ? :destination_id : :source_id
    account_id = data[account_id_key]
    account_id.nil? || account_id.to_s == transaction.account.id.to_s
  end

  def new_amount
    data[:amount] ? Monetize.parse(data[:amount]) : transaction.amount
  end

  def update_transaction
    transaction.update(data) ? Success() : Failure[:transaction_invalid, nil]
  end
end
