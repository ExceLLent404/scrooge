RSpec.shared_examples "of checking resource ownership" do |resource_name|
  context "when #{resource_name.to_s.camelcase} with the specified id belongs to another User" do
    let(:id) { create(resource_name).id }

    include_examples "of redirection to list of", resource_name.to_s.pluralize
  end
end

RSpec.shared_examples "of checking associated resource ownership" do |resource_name, id_name|
  context "when #{resource_name.to_s.camelcase} with the specified #{id_name} belongs to another User" do
    let(id_name) { create(resource_name).id }

    include_examples "of response status", :unprocessable_content
  end
end
