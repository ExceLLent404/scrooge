namespace :money do
  desc "Update exchange rates to the latest ones"
  task update_exchange_rates: [:environment] do
    Money.default_bank.update_rates
  end
end
