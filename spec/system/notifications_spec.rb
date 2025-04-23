require "system_helper"

RSpec.describe "Notifications" do
  describe "Clicking on the cross on a notification" do
    it "closes the notification" do
      visit root_path

      expect(page).to have_css(".notification.is-danger")

      find(".notification.is-danger").find_button.click

      expect(page).to have_no_css(".notification.is-danger")
    end
  end
end
