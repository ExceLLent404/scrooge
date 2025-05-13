class CancelTransaction < Operation
  option :transaction, reader: :private

  def call
    Try[Account::NotEnoughBalance] { transaction.cancel }
      .to_result
      .fmap { transaction.account.save! }
      .or { |exception| Failure[:not_enough_balance, exception.message] }
  end
end
