class Accounting
  class TransactionsAmountsByCategories
    def initialize(transactions, categories, currency)
      @transactions = transactions
      @categories = categories
      @currency = currency
    end

    def result
      transactions_by_categories.transform_values! do |transactions|
        TransactionsAmount.new(transactions, @currency).value
      end
    end

    private

    attr_reader :categories, :transactions

    def transactions_by_categories
      categories.each_with_object({}) do |category, memo|
        key = category.is_a?(IncomeCategory) ? :source : :destination
        association_type = "#{key}_type"
        association_id = "#{key}_id"
        transactions_by_category = transactions.select do |transaction|
          transaction.send(association_type) == "Category" && transaction.send(association_id) == category.id
        end
        memo[category] = transactions_by_category
      end
    end
  end
end
