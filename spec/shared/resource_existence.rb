RSpec.shared_examples "of checking resource existence" do |resource_name|
  context "when there is no #{resource_name.to_s.camelcase} with the specified id" do
    let(:id) { 0 }

    include_examples "of redirection to list of", resource_name.to_s.pluralize
  end
end

RSpec.shared_examples "of checking associated resource existence" do |resource_name, id_name|
  context "when there is no #{resource_name.to_s.camelcase} with the specified #{id_name}" do
    let(id_name) { 0 }

    include_examples "of response status", :unprocessable_content
  end
end
