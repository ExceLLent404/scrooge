require "rails_helper"

RSpec.describe "Accounts requests" do
  include_context "with authenticated user"

  describe "GET /accounts" do
    let(:request) { get accounts_url }

    include_examples "of response status", :ok
  end
end
