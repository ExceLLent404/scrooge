RSpec.shared_examples "validation of email presence" do
  context "with empty email" do
    let(:email) { nil }

    it "pops up an error message" do
      act

      expect(field_validation_message("Email")).to eql("Please fill out this field.")
    end
  end
end

RSpec.shared_examples "validation of email format validity" do |button|
  context "with invalid email format" do
    let(:email) { "scrooge" }

    it "pops up an error message" do
      act

      expect(field_validation_message("Email")).to eql("Please include an '@' in the email address. '#{email}' is missing an '@'.")

      fill_in "Email", with: "#{email}@"

      form.click_on button

      expect(field_validation_message("Email")).to eql("Please enter a part following '@'. '#{email}@' is incomplete.")
    end
  end
end

RSpec.shared_examples "validation of email existence" do
  context "with unregistered email" do
    let(:email) { "scrooge@example.com" }

    it "shows an error message" do
      act

      expect(error_notification).to have_content("Please review the problems below:")
      expect(field_error("Email")).to have_content("not found")
    end
  end
end

RSpec.shared_examples "validation of email uniqueness" do
  context "with already registered email" do
    let(:email) { create(:user).email }

    it "shows an error message" do
      act

      expect(error_notification).to have_content("Please review the problems below:")
      expect(field_error("Email")).to have_content("has already been taken")
    end
  end
end

RSpec.shared_examples "validation of password presence" do |field_name|
  context "with empty password" do
    let(:password) { nil }

    it "pops up an error message" do
      act

      expect(field_validation_message(field_name || "Password")).to eql("Please fill out this field.")
    end
  end
end

RSpec.shared_examples "validation of minimum password length" do |field_name|
  context "with too short password" do
    let(:password) { "1" * (min_length - 1) }
    let(:min_length) { Rails.configuration.devise.password_length.min }

    it "pops up an error message" do
      act

      expect(field_validation_message(field_name || "Password"))
        .to eql("Please lengthen this text to #{min_length} characters or more (you are currently using #{min_length - 1} characters).")
    end
  end
end

RSpec.shared_examples "validation of password confirmation presence" do |field_name|
  context "with empty password confirmation" do
    let(:password_confirmation) { nil }

    it "pops up an error message" do
      act

      expect(field_validation_message(field_name || "Password confirmation")).to eql("Please fill out this field.")
    end
  end
end

RSpec.shared_examples "validation of matching password with its confirmation" do |field_name|
  context "when the password does not match its confirmation" do
    let(:password_confirmation) { "!#{password}" }

    it "shows an error message" do
      act

      expect(error_notification).to have_content("Please review the problems below:")
      expect(field_error(field_name || "Password confirmation"))
        .to have_content("doesn't match Password")
    end
  end
end

RSpec.shared_examples "validation of current password presence" do
  context "with empty current password" do
    let(:current_password) { nil }

    it "pops up an error message" do
      act

      expect(field_validation_message("Current password")).to eql("Please fill out this field.")
    end
  end
end

RSpec.shared_examples "validation of current password validity" do
  context "with invalid current password" do
    let(:current_password) { "!#{user.password}" }

    it "shows an error message" do
      act

      expect(error_notification).to have_content("Please review the problems below:")
      expect(field_error("Current password")).to have_content("is invalid")
    end
  end
end
