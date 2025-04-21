require "system_helper"

RSpec.shared_examples "for navigation bar" do |location|
  it "contains a menu of application sections #{location}" do
    expect(navbar).to have_link("Capital")
    expect(navbar).to have_link("Accounts")
    expect(navbar).to have_link("Transactions")
    expect(navbar).to have_link("Categories")
  end

  it "contains user name #{location}" do
    expect(navbar).to have_content("User")
  end

  it "contains `Sign out` button #{location}" do
    expect(navbar).to have_link("Sign out")
  end
end

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

    context "on desktop" do
      include_examples "for navigation bar", "on itself"
    end

    context "on mobile" do
      before do
        resize_window_to_mobile

        find(".navbar-burger").click
      end

      after { resize_window_to_default }

      include_examples "for navigation bar", "behind the hamburger menu"
    end
  end
end
