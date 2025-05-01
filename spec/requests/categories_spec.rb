require "rails_helper"

RSpec.describe "Categories requests" do
  include_context "with authenticated user"

  describe "GET /categories" do
    let(:request) { get categories_url }

    include_examples "of response status", :ok
  end
end
