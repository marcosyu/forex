class DailyExchangeRatesJob < ApplicationJob
  queue_as :daily_exchange_rates_job

  def perform(provider)
    ExchangeRateServices.new({provider: provider, action:'latest'}).call
  end
end
