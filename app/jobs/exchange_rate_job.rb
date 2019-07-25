class ExchangeRateJob < ApplicationJob
  @queue = :exchange_rate_job

  def perform(exchange_rate_id)
    ExchangeRateService.new(exchange_rate_id).get_histories
  end
end
