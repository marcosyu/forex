class FetchPopularExchangeRatesJob < ApplicationJob
  @queue = :fetch_popular_exchange_rates_job

  def perform
    ExchangeRateServices.fetch_popular_exchange_rates_job
  end

end
