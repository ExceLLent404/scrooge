require "system_helper"

RSpec.describe "Visiting root page" do
  example do
    visit root_path

    expect(page).to have_content("Test#index")
  end
end
