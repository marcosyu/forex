class ExchangeRateJob < ApplicationJob
  @queue = :exchange_rate_job

  def perform(exchange_rate_id)
    ExchangeRateServices.new(exchange_rate_id).get_histories
  end
end
