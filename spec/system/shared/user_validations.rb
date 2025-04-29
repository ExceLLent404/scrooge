RSpec.shared_examples "validation of email presence" do
  context "with empty email" do
    let(:email) { nil }

    it "pops up an error message" do
      act

      expect(field_validation_message("Email")).to eql(t("chrome.validations.required"))
    end
  end
end

RSpec.shared_examples "validation of email format validity" do |button|
  context "with invalid email format" do
    let(:email) { "scrooge" }

    it "pops up an error message" do
      act

      expect(field_validation_message("Email")).to eql(t("chrome.validations.email.invalid", email:))

      fill_in "Email", with: "#{email}@"

      form.click_on button

      expect(field_validation_message("Email")).to eql(t("chrome.validations.email.incomplete", email: "#{email}@"))
    end
  end
end

RSpec.shared_examples "validation of email existence" do
  context "with unregistered email" do
    let(:email) { "scrooge@example.com" }

    it "shows an error message" do
      act

      expect(error_notification).to have_content(t("simple_form.error_notification.default_message"))
      expect(field_error("Email")).to have_content(t("errors.messages.not_found"))
    end
  end
end

RSpec.shared_examples "validation of email uniqueness" do
  context "with already registered email" do
    let(:email) { create(:user).email }

    it "shows an error message" do
      act

      expect(error_notification).to have_content(t("simple_form.error_notification.default_message"))
      expect(field_error("Email")).to have_content(t("errors.messages.taken"))
    end
  end
end

RSpec.shared_examples "validation of password presence" do |field_name|
  context "with empty password" do
    let(:password) { nil }

    it "pops up an error message" do
      act

      expect(field_validation_message(field_name || "Password")).to eql(t("chrome.validations.required"))
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
        .to eql(t("chrome.validations.too_short", min_length:, current_length: min_length - 1))
    end
  end
end

RSpec.shared_examples "validation of password confirmation presence" do |field_name|
  context "with empty password confirmation" do
    let(:password_confirmation) { nil }

    it "pops up an error message" do
      act

      expect(field_validation_message(field_name || "Password confirmation")).to eql(t("chrome.validations.required"))
    end
  end
end

RSpec.shared_examples "validation of matching password with its confirmation" do |field_name|
  context "when the password does not match its confirmation" do
    let(:password_confirmation) { "!#{password}" }

    it "shows an error message" do
      act

      expect(error_notification).to have_content(t("simple_form.error_notification.default_message"))
      expect(field_error(field_name || "Password confirmation"))
        .to have_content(t("errors.messages.confirmation", attribute: "Password"))
    end
  end
end

RSpec.shared_examples "validation of current password presence" do
  context "with empty current password" do
    let(:current_password) { nil }

    it "pops up an error message" do
      act

      expect(field_validation_message("Current password")).to eql(t("chrome.validations.required"))
    end
  end
end

RSpec.shared_examples "validation of current password validity" do
  context "with invalid current password" do
    let(:current_password) { "!#{user.password}" }

    it "shows an error message" do
      act

      expect(error_notification).to have_content(t("simple_form.error_notification.default_message"))
      expect(field_error("Current password")).to have_content(t("errors.messages.invalid"))
    end
  end
end
