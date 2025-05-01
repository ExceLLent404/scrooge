require "rails_helper"

RSpec.describe "Capital requests" do
  include_context "with authenticated user"

  describe "GET /capital" do
    let(:request) { get capital_url }

    include_examples "of response status", :ok
  end
end
