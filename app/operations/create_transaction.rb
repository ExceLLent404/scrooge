class CreateTransaction < Operation
  option :transaction, reader: :private

  option :perform_transaction, default: -> { PerformTransaction }, reader: :private

  def call
    yield validate_transaction

    ActiveRecord::Base.transaction do
      yield perform_transaction.call(transaction:)
      yield save_transaction
    end

    Success(transaction)
  end

  private

  def validate_transaction
    transaction.valid? ? Success() : Failure[:transaction_invalid, nil]
  end

  def save_transaction
    transaction.save ? Success() : Failure[:transaction_invalid, nil]
  end
end
