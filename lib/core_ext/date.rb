class Date
  # @return [String] a verbal description of the date in relation to the current date
  def to_relative_in_words
    return I18n.t("date.today") if today?
    return I18n.t("date.yesterday") if yesterday?

    I18n.l(self, format: current_year? ? :verbal_without_year : :verbal_with_year)
  end

  # @return [Boolean] is the date in the current year or not
  def current_year?
    year == Date.current.year
  end
end
