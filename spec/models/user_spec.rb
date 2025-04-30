require "rails_helper"

RSpec.describe User do
  subject(:user) { build(:user) }

  it { is_expected.to be_an(ApplicationRecord) }

  describe "#name" do
    subject(:name) { user.name }

    it { is_expected.to be_an_instance_of(String).or(be_nil) }

    it "cannot be empty" do
      user.name = ""
      expect(name).to be_nil
    end

    it "does not contain whitespace on the left and right" do
      user.name = "\t\n\v\f\r name \t\n\v\f\r"
      expect(name).to eql("name")
    end

    it "can contain only one space character between non whitespace characters" do
      user.name = "na \t \n \v \f \r me"
      expect(name).to eql("na me")
    end
  end

  describe "#email" do
    subject(:email) { user.email }

    it { is_expected.to be_an_instance_of(String) }

    it "cannot be absent" do
      expect(build(:user, email: nil)).not_to be_valid
    end

    it "cannot be empty" do
      expect(build(:user, email: "")).not_to be_valid
    end

    it "is a valid email" do
      expect(build(:user, email: "@incorrect-email")).not_to be_valid
    end

    it "does not contain whitespace on the left and right" do
      user.email = "\t\n\v\f\r email@example.com \t\n\v\f\r"
      expect(email).to eql("email@example.com")
    end

    it "consists of downcase characters" do
      user.email = "EMAIL@Example.Com"
      expect(email).to eql("email@example.com")
    end

    it "is unique" do
      create(:user, email:)

      expect(user).not_to be_valid
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
