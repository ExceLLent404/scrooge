Sentry.init do |config|
  config.dsn = "https://20df4b8103f614ddea1b07b9792c2cf0@o4508080849158144.ingest.de.sentry.io/4508080856891472"

  # Get breadcrumbs from logs
  config.breadcrumbs_logger = %i[active_support_logger http_logger redis_logger]

  # Set traces_sample_rate to 1.0 to capture 100% of transactions for tracing.
  # We recommend adjusting this value in production.
  config.traces_sample_rate = 1.0

  # Set profiles_sample_rate to profile 100% of sampled transactions.
  # We recommend adjusting this value in production.
  config.profiles_sample_rate = 1.0

  # Not to send module (dependency) information to Sentry.
  config.send_modules = false

  config.enabled_environments = %w[development production]
end
