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

group :development do
  gem "web-console", "~> 4.0"

  gem "erb_lint", "~> 0.9.0", require: false
  gem "rails_best_practices", "~> 1.0", require: false
  gem "reek", "~> 6.0", require: false
  gem "rubycritic", "~> 4.0", require: false
  gem "rubocop", "~> 1.0", require: false
  gem "rubocop-performance", "~> 1.0", require: false
  gem "rubocop-rails", "~> 2.0", require: false
  gem "standard", "~> 1.0", require: false
  gem "standard-rails", "~> 1.0", require: false

  gem "ruby-lsp-rails", "~> 0.4.0"

  gem "brakeman", "~> 7.0", require: false
end

group :development, :test do
  gem "debug", "~> 1.0", platforms: %i[mri windows], require: "debug/prelude"
end
