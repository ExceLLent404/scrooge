require "rails_helper"

RSpec.describe Category do
  subject(:category) { build(:category) }

  it { is_expected.to be_an(ApplicationRecord) }

  it "cannot be abstract" do
    expect { described_class.new }.to raise_error(ActiveRecord::SubclassNotFound)
    expect { described_class.new(type: nil) }.to raise_error(ActiveRecord::SubclassNotFound)
    expect { described_class.new(type: "") }.to raise_error(ActiveRecord::SubclassNotFound)

    expect(described_class.new(type: "IncomeCategory")).to be_an_instance_of(IncomeCategory)
    expect(described_class.new(type: "ExpenseCategory")).to be_an_instance_of(ExpenseCategory)
  end

  describe "#type" do
    subject { category.type }

    it { is_expected.to be_an_instance_of(String) }

    it "cannot be blank" do
      category.type = nil
      expect(category).not_to be_valid

      category.type = ""
      expect(category).not_to be_valid
    end

    it "can be only `IncomeCategory` or `ExpenseCategory`" do
      expect(build(:category, type: "IncomeCategory")).to be_valid
      expect(build(:category, type: "ExpenseCategory")).to be_valid
      expect { build(:category, type: "SomeOtherType") }.to raise_error(ActiveRecord::SubclassNotFound)
    end

    it "cannot be changed for persisted instance" do
      category = build_stubbed(:category)

      expect { category.type = "NewType" }.to raise_error(ActiveRecord::ReadonlyAttributeError)
      expect { category.attributes = {type: "NewType"} }.to raise_error(ActiveRecord::ReadonlyAttributeError)
    end
  end

  describe "#name" do
    subject(:name) { category.name }

    it { is_expected.to be_an_instance_of(String) }

    it "cannot be absent" do
      expect(build(:category, name: nil)).not_to be_valid
    end

    it "cannot be empty" do
      expect(build(:category, name: "")).not_to be_valid
    end

    it "does not contain whitespace on the left and right" do
      category.name = "\t\n\v\f\r name \t\n\v\f\r"
      expect(name).to eql("name")
    end

    it "can contain only one space character between non whitespace characters" do
      category.name = "na \t \n \v \f \r me"
      expect(name).to eql("na me")
    end
  end

  describe "#created_at" do
    subject { build_stubbed(:user).created_at }

    it { is_expected.to be_an_instance_of(ActiveSupport::TimeWithZone) }
  end

  describe "#updated_at" do
    subject { build_stubbed(:user).updated_at }

    it { is_expected.to be_an_instance_of(ActiveSupport::TimeWithZone) }
  end
end
