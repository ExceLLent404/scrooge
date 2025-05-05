require "rails_helper"

RSpec.describe Account do
  subject(:account) { build(:account) }

  it { is_expected.to be_an(ApplicationRecord) }

  describe "#name" do
    subject(:name) { account.name }

    it { is_expected.to be_an_instance_of(String) }

    it "cannot be absent" do
      expect(build(:account, name: nil)).not_to be_valid
    end

    it "cannot be empty" do
      expect(build(:account, name: "")).not_to be_valid
    end

    it "does not contain whitespace on the left and right" do
      account.name = "\t\n\v\f\r name \t\n\v\f\r"
      expect(name).to eql("name")
    end

    it "can contain only one space character between non whitespace characters" do
      account.name = "na \t \n \v \f \r me"
      expect(name).to eql("na me")
    end
  end

  describe "#balance_cents" do
    subject(:balance_cents) { account.balance_cents }

    it { is_expected.to be_an_instance_of(Integer) }

    it "cannot be absent" do
      expect(build(:account, balance_cents: nil)).not_to be_valid
    end

    it "is >= 0" do
      expect(balance_cents).to be >= 0
      expect(build(:account, balance_cents: -1)).not_to be_valid
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
