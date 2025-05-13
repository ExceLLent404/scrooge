class DeleteTransaction < Operation
  option :transaction, reader: :private

  option :cancel_transaction, default: -> { CancelTransaction }, reader: :private

  def call
    ActiveRecord::Base.transaction do
      yield cancel_transaction.call(transaction:)
      yield delete_transaction
    end

    Success()
  end

  private

  def delete_transaction
    Try[ActiveRecord::RecordNotDestroyed] { transaction.destroy! }
      .to_result
      .or { |exception| Failure[:not_deleted, exception.message] }
  end
end
