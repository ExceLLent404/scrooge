RSpec.shared_examples "validation of 'From'-'To' period boundaries correctness" do
  context "when 'From' is greater than the current date" do
    let(:from) { Date.tomorrow }

    it "pops up an error message" do
      act

      expect(field_validation_message("From"))
        .to eql(t("chrome.validations.date.less_than", date: l(Date.current, format: :chrome)))
    end
  end

  context "when 'From' is greater than 'To'" do
    let(:from) { Date.current }
    let(:to) { Date.yesterday }
    let(:js_timeout) { 0.3 }

    it "shows an error message" do
      act

      # TODO: get rid of using 'sleep'
      sleep(js_timeout + 0.1) # wait until the page refreshes after specifing the period to be able to view the error message

      expect(field_error("From")).to have_content(t("errors.messages.not_greater_than", count: "To"))
    end
  end

  context "when 'To' is greater than the current date" do
    let(:to) { Date.tomorrow }

    it "pops up an error message" do
      act

      expect(field_validation_message("To"))
        .to eql(t("chrome.validations.date.less_than", date: l(Date.current, format: :chrome)))
    end
  end
end
