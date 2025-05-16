class Accounting
  class TransactionsAmount
    def initialize(transactions, currency)
      @transactions = transactions
      @currency = currency
    end

    def value
      @transactions.sum(Money.zero(@currency), &:amount)
    end
  end
end
