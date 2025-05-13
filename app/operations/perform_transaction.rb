class PerformTransaction < Operation
  option :transaction, reader: :private

  def call
    Try[Account::NotEnoughBalance] { transaction.perform }
      .to_result
      .fmap { transaction.account.save! }
      .or { |exception| Failure[:not_enough_balance, exception.message] }
  end
end
