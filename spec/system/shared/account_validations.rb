RSpec.shared_examples "validation of account name presence" do
  context "with empty name" do
    let(:name) { nil }

    it "pops up an error message" do
      act

      expect(field_validation_message("Name")).to eql(t("chrome.validations.required"))
    end
  end
end

RSpec.shared_examples "validation of account balance presence" do
  context "with empty balance" do
    let(:balance) { nil }

    it "pops up an error message" do
      act

      expect(field_validation_message("Balance cents")).to eql(t("chrome.validations.required"))
    end
  end
end

RSpec.shared_examples "validation of account balance non-negativity" do
  context "when balance is less than 0" do
    let(:balance) { -1 }

    it "pops up an error message" do
      act

      expect(field_validation_message("Balance cents")).to eql(t("chrome.validations.greater_than_or_equal_to", count: 0))
    end
  end
end
