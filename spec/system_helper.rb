require "rails_helper"

require "capybara/rails"
require "capybara/rspec"
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

RSpec.configure do |config|
  config.before(:each, type: :system) { driven_by :chrome }
end
