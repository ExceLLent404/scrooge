# Behavior of models that have a currency attribute that is:
#   - a Money::Currency object;
#   - supported by the application (see Money::Currency.all);
#   - stored as upcased iso code.
module HasCurrency
  extend ActiveSupport::Concern

  class_methods do
    def has_currency(attribute, normalize: false)
      class_eval do
        normalizes attribute, with: ->(currency) { currency.upcase } if normalize

        validates attribute, presence: {
          message: I18n.t(
            "errors.messages.one_of",
            list: Money::Currency.all.to_sentence(last_word_connector: I18n.t("support.array.enum_connector"))
          )
        }
      end

      define_method :"#{attribute}=" do |value|
        currency = suppress(Money::Currency::UnknownCurrency) { value&.to_currency }
        super(currency)
      end

      define_method attribute do
        super()&.to_currency
      end
    end
  end
end
