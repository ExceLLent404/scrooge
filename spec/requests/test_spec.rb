require "rails_helper"

RSpec.describe "Test requests" do
  describe "GET /" do
    let(:request) { get root_url }

    context "when user is signed in" do
      include_context "with authenticated user"

      include_examples "of response status", :ok
    end

    context "when user is not signed in" do
      specify do
        request
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
