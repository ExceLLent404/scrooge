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
  context "when amount is less than or equal to 0" do
    let(:amount) { [-1, 0].sample }

    it "pops up an error message" do
      act

      expect(field_validation_message("Amount")).to eql(t("chrome.validations.custom.greater_than", count: 0))
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

RSpec.shared_examples "validation of transaction committed date occurrence" do
  context "when committed date is greater than the current one" do
    let(:committed_date) { Date.tomorrow }

    it "pops up an error message" do
      act

      expect(field_validation_message("Committed date"))
        .to eql(t("chrome.validations.date.less_than", date: l(Date.current, format: :chrome)))
    end
  end
end
