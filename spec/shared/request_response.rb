RSpec.shared_examples "of response status" do |status|
  specify do
    request
    expect(response).to have_http_status(status)
  end
end

RSpec.shared_examples "of redirection to list of" do |collection|
  specify do
    request
    expect(response).to redirect_to(send(:"#{collection}_path"))
  end
end
