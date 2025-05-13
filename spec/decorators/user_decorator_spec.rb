require "rails_helper"

RSpec.describe UserDecorator do
  subject(:decorated_user) { user.decorate }

  describe "#name" do
    subject(:name) { decorated_user.name }

    context "when user has no name" do
      let(:user) { build(:user, :without_name, email: "user-email@email.com") }

      it "returns a part of user email before the `@` sign" do
        expect(name).to eql("user-email")
      end
    end

    context "when user has name" do
      let(:user) { build(:user, :with_name) }

      it "returns the user name" do
        expect(name).to eql(user.name)
      end
    end
  end

  describe "#avatar_path" do
    subject(:avatar_path) { decorated_user.avatar_path }

    context "when user does not have the avatar" do
      let(:user) { build(:user) }

      it { is_expected.to include("default") }
    end
  end
end
