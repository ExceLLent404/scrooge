require "rails_helper"

RSpec.describe "Test requests" do
  include_context "with authenticated user"

  describe "GET /" do
    let(:request) { get root_url }

    include_examples "of response status", :ok
    include_examples "of user authentication"
  end
end
