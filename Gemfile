source "https://rubygems.org"

gem "rails", "~> 7.2.0"

gem "pg", "~> 1.0"

gem "puma", "~> 6.0"

gem "bootsnap", "~> 1.0", require: false

gem "cssbundling-rails", "~> 1.0"
gem "jsbundling-rails", "~> 1.0"
gem "sprockets-rails", "~> 3.0"
gem "turbo-rails", "~> 2.0"
gem "stimulus-rails", "~> 1.0"

gem "simple_form", "~> 5.0"

group :development do
  gem "web-console", "~> 4.0"

  gem "letter_opener_web", "~> 3.0"

  gem "erb_lint", "~> 0.9.0", require: false
  gem "rails_best_practices", "~> 1.0", require: false
  gem "reek", "~> 6.0", require: false
  gem "rubycritic", "~> 4.0", require: false
  gem "rubocop", "~> 1.0", require: false
  gem "rubocop-performance", "~> 1.0", require: false
  gem "rubocop-rails", "~> 2.0", require: false
  gem "rubocop-rspec", "~> 3.0", require: false
  gem "rubocop-rspec_rails", "~> 2.0", require: false
  gem "rubocop-factory_bot", "~> 2.0", require: false
  gem "rubocop-capybara", "~> 2.0", require: false
  gem "standard", "~> 1.0", require: false
  gem "standard-rails", "~> 1.0", require: false

  gem "ruby-lsp-rails", "~> 0.4.0"

  gem "database_consistency", "~> 2.0", require: false

  gem "brakeman", "~> 7.0", require: false
  gem "bundler-audit", "~> 0.9.0", require: false

  gem "bundle_update_interactive", "~> 0.11.0", require: false

  gem "yard", "~> 0.9.0", require: false
end

group :development, :test do
  gem "debug", "~> 1.0", platforms: %i[mri windows], require: "debug/prelude"

  gem "bullet", "~> 8.0"

  gem "factory_bot_rails", "~> 6.0"
  gem "faker", "~> 3.0"
  gem "rspec-rails", "~> 7.0"
end

group :test do
  gem "capybara", "~> 3.0", require: false
  gem "capybara-email", "~> 3.0", require: false
  gem "selenium-webdriver", "~> 4.0", require: false

  gem "simplecov", "~> 0.22.0", require: false
  gem "simplecov-cobertura", "~> 2.0", require: false

  gem "stackprof", "~> 0.2.0", require: false
  gem "test-prof", "~> 1.0", require: false
end
