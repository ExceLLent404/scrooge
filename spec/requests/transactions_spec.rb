require "rails_helper"

RSpec.describe "Transactions requests" do
  include_context "with authenticated user"

  describe "GET /transactions" do
    let(:request) { get transactions_url }

    include_examples "of response status", :ok
  end
end
