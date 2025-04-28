RSpec.shared_context "with authenticated user" do
  # user, i.e. current user, i.e. authenticated user
  let(:user) { create(:user) }

  before { sign_in(user) }
end
