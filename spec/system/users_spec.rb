require "system_helper"

RSpec.describe "Users" do
  describe "Signing up" do
    def act
      visit root_path

      navbar.click_on t("devise.shared.links.sign_up")

      fill_in "Name", with: user.name
      fill_in "Email", with: email
      fill_in "Password", with: password, match: :first
      fill_in "Password confirmation", with: password_confirmation
      select preferred_currency
      select time_zone

      form.click_on t("devise.registrations.new.sign_up")
    end

    let(:user) { build(:user) }
    let(:email) { user.email }
    let(:password) { user.password }
    let(:password_confirmation) { password }
    let(:preferred_currency) { attributes_for(:user)[:preferred_currency].symbol }
    let(:time_zone) { ActiveSupport::TimeZone.new(attributes_for(:user)[:time_zone]).to_s }

    it "requires confirmation of the registered user's email via a link in the sent email" do
      act

      expect(success_notification).to have_content(t("devise.registrations.signed_up_but_unconfirmed"))
      expect(open_email(email)).to have_content(t("devise.mailer.confirmation_instructions.action"))
    end

    it_behaves_like "validation of email presence"
    it_behaves_like "validation of email format validity", I18n.t("devise.registrations.new.sign_up")
    it_behaves_like "validation of email uniqueness"
    it_behaves_like "validation of password presence" do
      let(:password_confirmation) { user.password }
    end
    it_behaves_like "validation of minimum password length"
    it_behaves_like "validation of password confirmation presence"
    it_behaves_like "validation of matching password with its confirmation"
  end

  describe "Resending confirmation instructions" do
    def act
      visit root_path

      navbar.click_on t("devise.shared.links.sign_in")
      click_on t("devise.shared.links.didn_t_receive_confirmation_instructions")

      fill_in "Email", with: email

      click_on t("devise.confirmations.new.resend_confirmation_instructions")
    end

    let(:email) { create(:user, :unconfirmed).email }

    it "sends an email with confirmation instructions" do
      act

      expect(success_notification).to have_content(t("devise.confirmations.send_instructions"))
      expect(emails_sent_to(email).count).to be(2)
      expect(emails_sent_to(email)).to all(have_content(t("devise.mailer.confirmation_instructions.action")))
    end

    it_behaves_like "validation of email presence"
    it_behaves_like "validation of email format validity", I18n.t("devise.confirmations.new.resend_confirmation_instructions")
    it_behaves_like "validation of email existence"

    context "when email has already been confirmed" do
      let(:email) { create(:user).email }

      it "shows an error message" do
        act

        expect(error_notification).to have_content(t("simple_form.error_notification.default_message"))
        expect(field_error("Email")).to have_content(t("errors.messages.already_confirmed"))
      end
    end
  end

  describe "Email confirmation" do
    it "activates user profile" do
      user = create(:user, :unconfirmed)

      open_email(user.email).click_on t("devise.mailer.confirmation_instructions.action")

      expect(success_notification).to have_content(t("devise.confirmations.confirmed"))
    end
  end

  describe "Signing in" do
    def act
      visit root_path

      navbar.click_on t("devise.shared.links.sign_in")

      fill_in "Email", with: email
      fill_in "Password", with: password

      form.click_on t("devise.sessions.new.sign_in")
    end

    let(:user) { create(:user, :with_name) }
    let(:email) { user.email }
    let(:password) { user.password }
    let(:authentication_keys) do
      # from Devise::FailureApp#i18n_message
      # https://github.com/heartcombo/devise/blob/a259ff3c28912a27329727f4a3c2623d3f5cb6f2/lib/devise/failure_app.rb#L105
      User.authentication_keys.map { |key| User.human_attribute_name(key) }.join(t("support.array.words_connector"))
    end

    it "allows user to sign in" do
      act

      expect(success_notification).to have_content(t("devise.sessions.signed_in"))
      expect(navbar).to have_content(user.name).and have_link(t("devise.shared.links.sign_out"))
    end

    it_behaves_like "validation of email presence"
    it_behaves_like "validation of email format validity", I18n.t("devise.sessions.new.sign_in")

    context "with unregistered email" do
      let(:email) { "scrooge@example.com" }

      it "shows an error notification" do
        act

        expect(error_notification).to have_content(t("devise.failure.invalid", authentication_keys:))
      end
    end

    context "when email has not yet been confirmed" do
      let(:user) { create(:user, :unconfirmed) }

      it "shows an error notification" do
        act

        expect(error_notification).to have_content(t("devise.failure.unconfirmed"))
      end
    end

    it_behaves_like "validation of password presence" do
      let(:email) { "email-that-does-not-trigger-user-creation@example.com" }
    end
    it_behaves_like "validation of minimum password length" do
      let(:email) { "email-that-does-not-trigger-user-creation@example.com" }
    end

    context "with invalid password" do
      let(:password) { "!#{user.password}" }

      it "shows an error notification" do
        act

        expect(error_notification).to have_content(t("devise.failure.invalid", authentication_keys:))
      end
    end
  end

  describe "Receiving reset password instructions" do
    def act
      visit root_path

      navbar.click_on t("devise.shared.links.sign_in")
      click_on t("devise.shared.links.forgot_your_password")

      fill_in "Email", with: email

      click_on t("devise.passwords.new.receive_instructions")
    end

    let(:email) { create(:user).email }

    it "sends an email with reset password instructions" do
      act

      expect(success_notification).to have_content(t("devise.passwords.send_instructions"))
      expect(open_email(email)).to have_content(t("devise.mailer.reset_password_instructions.action"))
    end

    it_behaves_like "validation of email presence"
    it_behaves_like "validation of email format validity", I18n.t("devise.passwords.new.receive_instructions")
    it_behaves_like "validation of email existence"
  end

  describe "Password reset" do
    before { user.send_reset_password_instructions }

    def act
      open_email(user.email).click_on t("devise.mailer.reset_password_instructions.action")

      fill_in "New password", with: password
      fill_in "Confirm new password", with: password_confirmation

      click_on t("devise.passwords.edit.change_my_password")
    end

    let(:user) { create(:user) }
    let(:password) { "p@ssw0rd" }
    let(:password_confirmation) { password }

    it "updates user password and sends a notification email" do
      act

      expect(success_notification).to have_content(t("devise.passwords.updated_not_active"))
      expect(open_email(user.email)).to have_content(t("devise.mailer.password_change.message"))
    end

    context "when the available time to change the password has expired" do
      before { user.update!(reset_password_sent_at: Time.current - available_time) }

      let(:available_time) { Rails.configuration.devise.reset_password_within }
      let(:reset_password_token_error) { form.find(".help.is-danger") }

      it "shows an error message" do
        act

        expect(error_notification).to have_content(t("simple_form.error_notification.default_message"))
        expect(reset_password_token_error)
          .to have_content("Reset password token #{t("errors.messages.expired")}")
      end
    end

    it_behaves_like "validation of password presence", "New password" do
      let(:password_confirmation) { "p@ssw0rd" }
    end
    it_behaves_like "validation of minimum password length", "New password"
    it_behaves_like "validation of password confirmation presence", "Confirm new password"
    it_behaves_like "validation of matching password with its confirmation", "Confirm new password"
  end

  describe "Viewing profile" do
    let(:user) { create(:user, :with_name) }

    it "displays user data" do
      sign_in(user)

      visit root_path

      click_on user.name

      expect(page)
        .to have_field("Name", with: user.name)
        .and have_field("Email", with: user.email)
        .and have_select("Preferred currency", selected: user.preferred_currency.symbol)
        .and have_select("Time zone", selected: ActiveSupport::TimeZone.new(user.time_zone).to_s)
    end
  end

  describe "Changing user data" do
    before { sign_in(user) }

    def act
      visit root_path

      click_on user.name

      fill_in "Name", with: name
      select preferred_currency
      select time_zone
      fill_in "Current password", with: current_password

      click_on t("devise.registrations.edit.update")
    end

    let(:user) { create(:user, :with_name) }
    let(:name) { "Updated #{user.name}" }
    let(:preferred_currency) { attributes_for(:user)[:preferred_currency].symbol }
    let(:time_zone) { ActiveSupport::TimeZone.new(attributes_for(:user)[:time_zone]).to_s }
    let(:current_password) { user.password }

    it "updates user data" do
      act

      expect(success_notification).to have_content(t("devise.registrations.updated"))
      expect(navbar).to have_content(name)
      expect(page)
        .to have_field("Name", with: name)
        .and have_select("Preferred currency", selected: preferred_currency)
        .and have_select("Time zone", selected: time_zone)
    end

    it_behaves_like "validation of current password presence"
    it_behaves_like "validation of current password validity"
  end

  describe "Changing email" do
    before { sign_in(user) }

    def act
      visit root_path

      click_on user.name

      fill_in "Email", with: email
      fill_in "Current password", with: current_password

      click_on t("devise.registrations.edit.update")
    end

    let(:user) { create(:user, :with_name) }
    let(:email) { attributes_for(:user)[:email] }
    let(:current_password) { user.password }

    it "sends a notification email to the former user email " \
       "and requires confirmation of the user's new email via a link in the sent email to the new email" do
      act

      expect(success_notification).to have_content(t("devise.registrations.update_needs_confirmation"))
      expect(open_email(user.email))
        .to have_content(t("devise.mailer.email_changed.message_unconfirmed", email:))
      expect(open_email(email)).to have_content(t("devise.mailer.confirmation_instructions.action"))
    end

    it_behaves_like "validation of email presence"
    it_behaves_like "validation of email format validity", I18n.t("devise.registrations.edit.update")
    it_behaves_like "validation of email uniqueness"
    it_behaves_like "validation of current password presence"
    it_behaves_like "validation of current password validity"
  end

  describe "Changing password" do
    before { sign_in(user) }

    def act
      visit root_path

      click_on user.name

      fill_in "New password", with: password
      fill_in "Confirm new password", with: password_confirmation
      fill_in "Current password", with: current_password

      click_on t("devise.registrations.edit.update")
    end

    let(:user) { create(:user, :with_name) }
    let(:password) { "p@ssw0rd" }
    let(:password_confirmation) { password }
    let(:current_password) { user.password }

    it "updates user password and sends a notification email" do
      act

      expect(success_notification).to have_content(t("devise.registrations.updated"))
      expect(open_email(user.email)).to have_content(t("devise.mailer.password_change.message"))
    end

    context "with empty password" do
      let(:password) { nil }
      let(:password_confirmation) { "p@ssw0rd" }

      it "shows an error message" do
        act

        expect(error_notification).to have_content(t("simple_form.error_notification.default_message"))
        expect(field_error("New password")).to have_content(t("errors.messages.blank"))
      end
    end

    it_behaves_like "validation of minimum password length", "New password"

    context "with empty password confirmation" do
      let(:password_confirmation) { nil }

      it "shows an error message" do
        act

        expect(error_notification).to have_content(t("simple_form.error_notification.default_message"))
        expect(field_error("Confirm new password"))
          .to have_content(t("errors.messages.confirmation", attribute: "Password"))
      end
    end

    it_behaves_like "validation of matching password with its confirmation", "Confirm new password"
    it_behaves_like "validation of current password presence"
    it_behaves_like "validation of current password validity"
  end

  describe "Signing out" do
    it "destroys user session" do
      sign_in(create(:user))

      visit root_path

      accept_confirm { click_on t("devise.shared.links.sign_out") }

      expect(success_notification).to have_content(t("devise.sessions.signed_out"))
      expect(page).to have_field("Email").and have_field("Password")
    end
  end
end
