require "system_helper"

RSpec.describe "Navigation bar" do
  context "when user is not signed in" do
    before { Rails.configuration.x.user_signed_in = false }

    it "contains `Sign up` and `Sign in` buttons" do
      visit root_path

      expect(navbar).to have_link("Sign up")
      expect(navbar).to have_link("Sign in")
    end
  end

  context "when user is signed in" do
    before do
      Rails.configuration.x.user_signed_in = true
      visit root_path
    end

    it "contains a menu of application sections" do
      expect(navbar).to have_link("Capital")
      expect(navbar).to have_link("Accounts")
      expect(navbar).to have_link("Transactions")
      expect(navbar).to have_link("Categories")
    end

    it "contains user name" do
      expect(navbar).to have_content("User")
    end

    it "contains `Sign out` button" do
      expect(navbar).to have_link("Sign out")
    end
  end
end
