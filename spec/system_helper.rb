require "rails_helper"

require "capybara/rails"
require "capybara/rspec"
require "capybara/email/rspec"
require "selenium-webdriver"

Capybara.server_host = Socket.ip_address_list.find(&:ipv4_private?).ip_address
Capybara.server_port = 3030

Capybara.register_driver :chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument("--window-size=1400,1000")
  options.add_argument("--headless=new") unless ENV["HEADLESS"].in?(%w[0 no false])

  browser_location = if ENV["CI"].present?
    {browser: :chrome}
  else
    {browser: :remote, url: "http://#{ENV.fetch("CHROME_HOST")}:#{ENV.fetch("CHROME_PORT")}"}
  end
  Capybara::Selenium::Driver.new(app, **browser_location, options:)
end

# Helpers for finding elements on the page based on Bulma classes
module BulmaHelpers
  def form
    find("form")
  end

  def navbar
    find(".navbar")
  end

  def success_notification
    find(".notification.is-success")
  end

  def error_notification
    find(".notification.is-danger")
  end
end

# Helpers for interacting with the browser
module BrowserHelpers
  def resize_window_to_mobile
    resize_window_to(480, 960)
  end

  def resize_window_to_default
    resize_window_to(1400, 1000)
  end

  private

  def resize_window_to(width, height)
    Capybara.current_session.current_window.resize_to(width, height)
  end
end

RSpec.configure do |config|
  config.before(:each, type: :system) { driven_by :chrome }

  # Set correct server host and port for emails
  config.around(:each, type: :system) do |example|
    default_options = ActionMailer::Base.default_url_options
    ActionMailer::Base.default_url_options = {host: Capybara.server_host, port: Capybara.server_port}
    example.run
    ActionMailer::Base.default_url_options = default_options
  end

  config.include BulmaHelpers, type: :system
  config.include BrowserHelpers, type: :system
end
