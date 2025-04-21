require "system_helper"

RSpec.describe "Navigation bar" do
  it "contains `Sign up` and `Sign in` buttons" do
    visit root_path

    expect(navbar).to have_link("Sign up")
    expect(navbar).to have_link("Sign in")
  end
end
