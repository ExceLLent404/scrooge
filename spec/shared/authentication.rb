RSpec.shared_context "with authenticated user" do
  # user, i.e. current user, i.e. authenticated user
  let(:user) { create(:user) }

  before { sign_in(user) }
end

RSpec.shared_examples "of user authentication" do
  it "requires user authentication" do
    sign_out(:user)
    request
    expect(response).to redirect_to(new_user_session_path)
  end
end
