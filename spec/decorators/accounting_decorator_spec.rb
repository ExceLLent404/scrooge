require "rails_helper"

RSpec.describe AccountingDecorator do
  subject(:decorated_accounting) { accounting.decorate }

  let(:accounting) { build(:accounting) }

  describe "#to_param" do
    subject { decorated_accounting.to_param }

    it { is_expected.not_to be_nil }
  end

  describe "#to_query" do
    subject(:query) { decorated_accounting.to_query(key) }

    let(:key) { :accounting }

    it { is_expected.to be_an_instance_of(String) }

    it "is a URL query string containing object attributes except the `user` one" do
      names = accounting.attributes.except("user").keys
      values = accounting.attributes.except("user").values

      names.each { |name| expect(query).to include(name.to_s) }
      values.each { |value| expect(query).to include(value.to_s) }
      expect(query).to include("&")
      expect(query).not_to include("user")
    end
  end
end
