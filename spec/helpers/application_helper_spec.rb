require "rails_helper"

RSpec.describe ApplicationHelper do
  describe "#icon" do
    subject(:html) { helper.icon(icon, options) }

    let(:icon) { "fas fa-lg fa-user" }
    let(:options) { {} }

    it "returns HTML code of the icon" do
      expect(html).to eql("<span class=\"icon\"><i class=\"#{icon}\"></i></span>")
    end

    context "when options contain class" do
      let(:options) { {class: "has-text-danger"} }

      it "inserts the class into the <span> wrapper" do
        expect(html).to eql("<span class=\"icon #{options[:class]}\"><i class=\"#{icon}\"></i></span>")
      end
    end
  end
end
