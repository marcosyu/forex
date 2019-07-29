class DailyExchangeRatesJob < ApplicationJob
  queue_as :daily_exchange_rates_job

  def perform(args)
    ExchangeRateServices.new({provider: args['provider'], action:'latest'}).call
  end
end
