class DateTimeInput < SimpleForm::Inputs::DateTimeInput
  DATE_TIME_OPTIONS = {
    min_max: true
  }.freeze

  def initialize(builder, attribute_name, column, input_type, options = {})
    options.reverse_merge!(DATE_TIME_OPTIONS)
    super
  end

  private

  def min_max(wrapper_options = nil)
    if (comparison_validator = find_validator(:comparison))
      validator_options = comparison_validator.options
      input_html_options[:min] ||= minimum_value(validator_options).to_s
      input_html_options[:max] ||= maximum_value(validator_options).to_s
    end

    super
  end
end
