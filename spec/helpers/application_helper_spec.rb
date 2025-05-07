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

  describe "#edit_object_path" do
    context "when object is a Category of any type" do
      it "returns `/categories/:id/edit` path" do
        %i[income_category expense_category].each do |category|
          object = build_stubbed(category)
          expect(helper.edit_object_path(object)).to eql("/categories/#{object.id}/edit")
        end
      end
    end

    context "when object is a Transaction of any type" do
      it "returns `/transactions/:id/edit` path" do
        %i[income expense].each do |transaction|
          object = build_stubbed(transaction)
          expect(helper.edit_object_path(object)).to eql("/transactions/#{object.id}/edit")
        end
      end
    end

    context "when object is another model" do
      it "returns `/<model pluralized name>/:id/edit` path" do
        object = build_stubbed(:account)
        expect(helper.edit_object_path(object)).to eql("/accounts/#{object.id}/edit")
      end
    end
  end

  describe "#object_path" do
    context "when object is a Category of any type" do
      it "returns `/categories/:id` path" do
        %i[income_category expense_category].each do |category|
          object = build_stubbed(category)
          expect(helper.object_path(object)).to eql("/categories/#{object.id}")
        end
      end
    end

    context "when object is a Transaction of any type" do
      it "returns `/transactions/:id` path" do
        %i[income expense].each do |transaction|
          object = build_stubbed(transaction)
          expect(helper.object_path(object)).to eql("/transactions/#{object.id}")
        end
      end
    end

    context "when object is another model" do
      it "returns `/<model pluralized name>/:id` path" do
        object = build_stubbed(:account)
        expect(helper.object_path(object)).to eql("/accounts/#{object.id}")
      end
    end
  end
end
