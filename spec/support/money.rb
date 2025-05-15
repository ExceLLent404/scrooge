require "money-rails/test_helpers"

# rubocop:disable Rails/FindEach
Money::Currency.all.each do |from|
  Money::Currency.all.each do |to|
    Money.default_bank.add_rate(from, to, rand.round(4))
  end
end
# rubocop:enable Rails/FindEach
