class CorrectTransaction < Operation
  option :transaction, reader: :private
  option :new_amount, reader: :private

  def call
    Try[Account::NotEnoughBalance] { transaction.correct(new_amount) }
      .to_result
      .fmap { transaction.account.save! }
      .or { |exception| Failure[:not_enough_balance, exception.message] }
  end
end
