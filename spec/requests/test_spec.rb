require "rails_helper"

RSpec.describe "Test requests" do
  describe "GET /" do
    specify do
      get root_url
      expect(response).to have_http_status(:ok)
    end
  end
end
