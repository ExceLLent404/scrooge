require "rails_helper"

RSpec.describe "Test requests" do
  describe "GET /" do
    context "when user is signed in" do
      include_context "with authenticated user"

      specify do
        get root_url
        expect(response).to have_http_status(:ok)
      end
    end

    context "when user is not signed in" do
      specify do
        get root_url
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
