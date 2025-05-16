class Accounting
  class TotalBalance
    def initialize(accounts, currency)
      @accounts = accounts
      @currency = currency
    end

    def value
      @accounts.sum(Money.zero(@currency), &:balance)
    end
  end
end
