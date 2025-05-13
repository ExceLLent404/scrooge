RSpec.shared_context "with authenticated user" do
  fixtures :users

  # user, i.e. current user, i.e. authenticated user
  let(:user) { users(:ordinary) }

  before { sign_in(user) }

  around { |example| Time.use_zone(user.time_zone, &example) }
end

RSpec.shared_examples "of user authentication" do
  it "requires user authentication" do
    sign_out(:user)
    request
    expect(response).to redirect_to(new_user_session_path)
  end
end
