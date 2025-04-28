require "system_helper"

RSpec.describe "Users" do
  describe "Signing up" do
    def act
      visit root_path

      navbar.click_on "Sign up"

      fill_in "Email", with: email
      fill_in "Password", with: password, match: :first
      fill_in "Password confirmation", with: password_confirmation

      form.click_on "Sign up"
    end

    let(:user) { build(:user) }
    let(:email) { user.email }
    let(:password) { user.password }
    let(:password_confirmation) { password }

    it "requires confirmation of the registered user's email via a link in the sent email" do
      act

      expect(error_notification).to have_content("You need to sign in or sign up before continuing.")
      expect(open_email(email)).to have_content("Confirm my account")
    end
  end

  describe "Resending confirmation instructions" do
    def act
      visit root_path

      navbar.click_on "Sign in"
      click_on "Didn't receive confirmation instructions?"

      fill_in "Email", with: email

      click_on "Resend confirmation instructions"
    end

    let(:email) { create(:user, :unconfirmed).email }

    it "sends an email with confirmation instructions" do
      act

      expect(success_notification).to have_content("You will receive an email with instructions for how to confirm your email address in a few minutes.")
      expect(emails_sent_to(email).count).to be(2)
      expect(emails_sent_to(email)).to all(have_content("Confirm my account"))
    end

    context "when email has already been confirmed" do
      let(:email) { create(:user).email }

      it "shows an error message" do
        act

        expect(error_notification).to have_content("Please review the problems below:")
        expect(field_error("Email")).to have_content("was already confirmed, please try signing in")
      end
    end
  end

  describe "Email confirmation" do
    it "activates user profile" do
      user = create(:user, :unconfirmed)

      open_email(user.email).click_on "Confirm my account"

      expect(success_notification).to have_content("Your email address has been successfully confirmed.")
    end
  end

  describe "Signing in" do
    def act
      visit root_path

      navbar.click_on "Sign in"

      fill_in "Email", with: email
      fill_in "Password", with: password

      form.click_on "Sign in"
    end

    let(:user) { create(:user) }
    let(:email) { user.email }
    let(:password) { user.password }

    it "allows user to sign in" do
      act

      expect(success_notification).to have_content("Signed in successfully.")
      expect(navbar).to have_link("Sign out")
    end

    context "with unregistered email" do
      let(:email) { "scrooge@example.com" }

      it "shows an error notification" do
        act

        expect(error_notification).to have_content("Invalid Email or password.")
      end
    end

    context "when email has not yet been confirmed" do
      let(:user) { create(:user, :unconfirmed) }

      it "shows an error notification" do
        act

        expect(error_notification).to have_content("You have to confirm your email address before continuing.")
      end
    end

    context "with invalid password" do
      let(:password) { "!#{user.password}" }

      it "shows an error notification" do
        act

        expect(error_notification).to have_content("Invalid Email or password.")
      end
    end
  end

  describe "Receiving reset password instructions" do
    def act
      visit root_path

      navbar.click_on "Sign in"
      click_on "Forgot your password?"

      fill_in "Email", with: email

      click_on "Receive instructions"
    end

    let(:email) { create(:user).email }

    it "sends an email with reset password instructions" do
      act

      expect(success_notification).to have_content("You will receive an email with instructions on how to reset your password in a few minutes.")
      expect(open_email(email)).to have_content("Change my password")
    end
  end

  describe "Password reset" do
    before { user.send_reset_password_instructions }

    def act
      open_email(user.email).click_on "Change my password"

      fill_in "New password", with: password
      fill_in "Confirm new password", with: password_confirmation

      click_on "Change my password"
    end

    let(:user) { create(:user) }
    let(:password) { "p@ssw0rd" }
    let(:password_confirmation) { password }

    it "updates user password" do
      act

      expect(success_notification).to have_content("Your password has been changed successfully.")
    end

    context "when the available time to change the password has expired" do
      before { user.update!(reset_password_sent_at: Time.current - available_time) }

      let(:available_time) { Rails.configuration.devise.reset_password_within }
      let(:reset_password_token_error) { form.find(".help.is-danger") }

      it "shows an error message" do
        act

        expect(error_notification).to have_content("Please review the problems below:")
        expect(reset_password_token_error)
          .to have_content("Reset password token has expired, please request a new one")
      end
    end
  end

  describe "Viewing profile" do
    let(:user) { create(:user) }

    it "displays user data" do
      sign_in(user)

      visit root_path

      click_on user.email.split("@").first

      expect(page).to have_field("Email", with: user.email)
    end
  end

  describe "Changing email" do
    before { sign_in(user) }

    def act
      visit root_path

      click_on user.email.split("@").first

      fill_in "Email", with: email
      fill_in "Current password", with: current_password

      click_on "Update"
    end

    let(:user) { create(:user) }
    let(:email) { attributes_for(:user)[:email] }
    let(:current_password) { user.password }

    it "requires confirmation of the user's new email via a link in the sent email to the new email" do
      act

      expect(success_notification)
        .to have_content("You updated your account successfully, but we need to verify your new email address. Please check your email and follow the confirmation link to confirm your new email address.")
      expect(open_email(email)).to have_content("Confirm my account")
    end
  end

  describe "Changing password" do
    before { sign_in(user) }

    def act
      visit root_path

      click_on user.email.split("@").first

      fill_in "New password", with: password
      fill_in "Confirm new password", with: password_confirmation
      fill_in "Current password", with: current_password

      click_on "Update"
    end

    let(:user) { create(:user) }
    let(:password) { "p@ssw0rd" }
    let(:password_confirmation) { password }
    let(:current_password) { user.password }

    it "updates user password" do
      act

      expect(success_notification).to have_content("Your account has been updated successfully.")
    end
  end

  describe "Signing out" do
    it "destroys user session" do
      sign_in(create(:user))

      visit root_path

      accept_confirm { click_on "Sign out" }

      expect(error_notification).to have_content("You need to sign in or sign up before continuing.")
      expect(page).to have_field("Email").and have_field("Password")
    end
  end
end
