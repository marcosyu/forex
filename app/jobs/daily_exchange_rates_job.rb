class DailyExchangeRatesJob < ApplicationJob
  @queue = :daily_exchange_rates_job

  def perform
    ExchangeRateServices.new.daily_update
  end
end
