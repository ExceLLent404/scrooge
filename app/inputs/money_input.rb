class MoneyInput < SimpleForm::Inputs::NumericInput
  MONEY_OPTIONS = {
    required: true,
    min_max: true
  }.freeze

  def initialize(builder, attribute_name, column, input_type, options = {})
    options.reverse_merge!(MONEY_OPTIONS)
    super
  end

  private

  def min_max(wrapper_options = nil)
    validator_options = find_validator(:money).options
    input_html_options[:min] ||= minimum_value(validator_options)
    input_html_options[:max] ||= maximum_value(validator_options)
  end
end
