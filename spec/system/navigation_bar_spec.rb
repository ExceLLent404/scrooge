require "system_helper"

RSpec.shared_examples "for navigation bar" do |location|
  it "contains a menu of application sections #{location}" do
    expect(navbar).to have_link(t("menu.capital"))
    expect(navbar).to have_link(t("menu.accounts"))
    expect(navbar).to have_link(t("menu.transactions"))
    expect(navbar).to have_link(t("menu.categories"))
  end

  it "contains part of user email before the `@` sign #{location}" do
    expect(navbar).to have_content(user.email.split("@").first)
  end

  it "contains `Sign out` button #{location}" do
    expect(navbar).to have_link(t("devise.shared.links.sign_out"))
  end
end

RSpec.describe "Navigation bar" do
  context "when user is not signed in" do
    it "contains `Sign up` and `Sign in` buttons" do
      visit root_path

      expect(navbar).to have_link(t("devise.shared.links.sign_up"))
      expect(navbar).to have_link(t("devise.shared.links.sign_in"))
    end
  end

  context "when user is signed in" do
    include_context "with authenticated user"

    before { visit root_path }

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
