source "https://rubygems.org"

gem "rails", "~> 7.2.2", ">= 7.2.2.1"

gem "pg", "~> 1.1"

gem "puma", ">= 5.0"

gem "bootsnap", require: false

gem "cssbundling-rails"
gem "jsbundling-rails"
gem "sprockets-rails"
gem "turbo-rails"
gem "stimulus-rails"

group :development do
  gem "web-console"

  gem "rubocop-rails-omakase", require: false

  gem "brakeman", require: false
end

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
end
