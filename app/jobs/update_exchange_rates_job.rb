class UpdateExchangeRatesJob < ApplicationJob
  queue_as :default

  sidekiq_options retry: 0

  def perform
    Money.default_bank.update_rates
  end
end
