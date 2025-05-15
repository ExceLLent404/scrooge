require "rails_helper"

RSpec.describe "Capital requests" do
  include_context "with authenticated user"

  describe "GET /capital" do
    let(:request) { get capital_url }

    before { %i[income expense].each { |type| create_pair(type, user:) } }

    include_examples "of response status", :ok
    include_examples "of user authentication"
  end
end
