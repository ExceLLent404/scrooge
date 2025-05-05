RSpec.shared_examples "validation of category name presence" do
  context "with empty name" do
    let(:name) { nil }

    it "pops up an error message" do
      act

      expect(field_validation_message("Name")).to eql(t("chrome.validations.required"))
    end
  end
end
