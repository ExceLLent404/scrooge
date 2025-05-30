require "money/bank/open_exchange_rates_bank"
require Rails.root.join("lib/money/rates_store/redis.rb")

# Limit the set of supported (allowed) currencies
white_list = %i[usd eur rub]
Money::Currency.table.keys.each do |currency|
  next if white_list.include?(currency)

  Money::Currency.unregister(currency)
end

MoneyRails.configure do |config|
  # To set the default currency
  config.default_currency = :usd

  redis_db = Rails.env.test? ? 15 : 1
  rates_store = Money::RatesStore::Redis.new(url: "#{ENV["REDIS_URL"]}/#{redis_db}")
  oxr = Money::Bank::OpenExchangeRatesBank.new(rates_store)

  oxr.app_id = ENV["OXR_APP_ID"].presence || Rails.application.credentials.oxr_app_id

  # (optional)
  # Minified Response ('prettyprint')
  # see https://docs.openexchangerates.org/docs/prettyprint
  oxr.prettyprint = false

  # Filter response to a list of symbols
  # see https://docs.openexchangerates.org/docs/get-specific-currencies
  oxr.symbols = Money::Currency.all.map(&:to_s).excluding(oxr.source)

  # Set default bank object
  #
  # Example:
  # config.default_bank = EuCentralBank.new
  config.default_bank = oxr

  # Add exchange rates to current money bank object.
  # (The conversion rate refers to one direction only)
  #
  # Example:
  # config.add_rate "USD", "CAD", 1.24515
  # config.add_rate "CAD", "USD", 0.803115
  if oxr.app_id.blank? && Rails.env.development?
    config.add_rate "USD", "EUR",   0.9000
    config.add_rate "EUR", "USD",   1.1111
    config.add_rate "USD", "RUB",  90.0000
    config.add_rate "RUB", "USD",   0.0111
    config.add_rate "EUR", "RUB", 100.0000
    config.add_rate "RUB", "EUR",   0.0100
  end

  # To handle the inclusion of validations for monetized fields
  # The default value is true
  #
  # config.include_validations = true

  # Default ActiveRecord migration configuration values for columns:
  #
  # config.amount_column = { prefix: '',           # column name prefix
  #                          postfix: '_cents',    # column name  postfix
  #                          column_name: nil,     # full column name (overrides prefix, postfix and accessor name)
  #                          type: :integer,       # column type
  #                          present: true,        # column will be created
  #                          null: false,          # other options will be treated as column options
  #                          default: 0
  #                        }
  #
  # config.currency_column = { prefix: '',
  #                            postfix: '_currency',
  #                            column_name: nil,
  #                            type: :string,
  #                            present: true,
  #                            null: false,
  #                            default: 'USD'
  #                          }

  # Register a custom currency
  #
  # Example:
  # config.register_currency = {
  #   priority:            1,
  #   iso_code:            "EU4",
  #   name:                "Euro with subunit of 4 digits",
  #   symbol:              "€",
  #   symbol_first:        true,
  #   subunit:             "Subcent",
  #   subunit_to_unit:     10000,
  #   thousands_separator: ".",
  #   decimal_mark:        ","
  # }

  # Specify a rounding mode
  # Any one of:
  #
  # BigDecimal::ROUND_UP,
  # BigDecimal::ROUND_DOWN,
  # BigDecimal::ROUND_HALF_UP,
  # BigDecimal::ROUND_HALF_DOWN,
  # BigDecimal::ROUND_HALF_EVEN,
  # BigDecimal::ROUND_CEILING,
  # BigDecimal::ROUND_FLOOR
  #
  # set to BigDecimal::ROUND_HALF_EVEN by default
  #
  config.rounding_mode = BigDecimal::ROUND_HALF_EVEN

  # Set default money format globally.
  # Default value is nil meaning "ignore this option".
  # Example:
  #
  # config.default_format = {
  #   no_cents_if_whole: nil,
  #   symbol: nil,
  #   sign_before_symbol: nil
  # }

  # If you would like to use I18n localization (formatting depends on the
  # locale):
  config.locale_backend = :i18n
  #
  # Example (using default localization from rails-i18n):
  #
  # I18n.locale = :en
  # Money.new(10_000_00, 'USD').format # => $10,000.00
  # I18n.locale = :es
  # Money.new(10_000_00, 'USD').format # => $10.000,00
  #
  # For the legacy behaviour of "per currency" localization (formatting depends
  # only on currency):
  # config.locale_backend = :currency
  #
  # Example:
  # Money.new(10_000_00, 'USD').format # => $10,000.00
  # Money.new(10_000_00, 'EUR').format # => €10.000,00
  #
  # In case you don't need localization and would like to use default values
  # (can be redefined using config.default_format):
  # config.locale_backend = nil

  # Set default raise_error_on_money_parsing option
  # It will be raise error if assigned different currency
  # The default value is false
  #
  # Example:
  # config.raise_error_on_money_parsing = false
end
