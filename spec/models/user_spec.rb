require "rails_helper"

RSpec.describe User do
  subject(:user) { build(:user) }

  it { is_expected.to be_an(ApplicationRecord) }

  it_behaves_like "it has timestamps"

  describe "#name" do
    subject(:name) { user.name }

    it { is_expected.to be_an_instance_of(String).or(be_nil) }

    it "cannot be empty" do
      user.name = ""
      expect(name).to be_nil
    end

    include_examples "of squished name" do
      let(:object) { user }
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

  describe "#time_zone" do
    subject(:time_zone) { user.time_zone }

    it { is_expected.to be_an_instance_of(String) }

    it "cannot be absent" do
      expect(build(:user, time_zone: nil)).not_to be_valid
    end

    it "is a valid time zone name" do
      expect(ActiveSupport::TimeZone.all.map(&:name)).to include(time_zone)

      expect(build(:user, time_zone: "UTC")).to be_valid
      expect(build(:user, time_zone: "invalid")).not_to be_valid
    end
  end
end
