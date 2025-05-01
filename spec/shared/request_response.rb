RSpec.shared_examples "of response status" do |status|
  specify do
    request
    expect(response).to have_http_status(status)
  end
end
