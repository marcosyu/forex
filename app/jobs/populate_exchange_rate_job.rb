class PopulateExchangeRateJob < ApplicationJob
  @queue = :populate_exchange_rate_job

  def perform(exchange_rate_id)
    ExchangeRateServices.new.populate_exchange_rates
  end

end
