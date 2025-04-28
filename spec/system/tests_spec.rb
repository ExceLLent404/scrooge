require "system_helper"

RSpec.describe "Visiting root page" do
  context "when user is signed in" do
    include_context "with authenticated user"

    example do
      visit root_path

      expect(page).to have_content("Test#index")
    end
  end

  context "when user is not signed in" do
    example do
      visit root_path

      expect(page).to have_content("You need to sign in or sign up before continuing.")
    end
  end
end
