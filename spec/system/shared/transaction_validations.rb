RSpec.shared_examples "validation of transaction amount presence" do
  context "with empty amount" do
    let(:amount) { nil }

    it "pops up an error message" do
      act

      expect(field_validation_message("Amount")).to eql(t("chrome.validations.required"))
    end
  end
end

RSpec.shared_examples "validation of transaction amount positivity" do
  context "when amount is less than 0" do
    let(:amount) { -1 }

    it "pops up an error message" do
      act

      expect(field_validation_message("Amount")).to eql(t("chrome.validations.greater_than_or_equal_to", count: 0))
    end
  end

  context "when amount is equal to 0" do
    let(:amount) { 0 }

    it "shows an error message" do
      act

      expect(error_notification).to have_content(t("simple_form.error_notification.default_message"))
      expect(field_error("Amount")).to have_content(t("errors.messages.greater_than", count: 0))
    end
  end
end

RSpec.shared_examples "validation of transaction committed date presence" do
  context "with empty committed date" do
    let(:committed_date) { nil }

    it "pops up an error message" do
      act

      expect(field_validation_message("Committed date")).to eql(t("chrome.validations.required"))
    end
  end
end
