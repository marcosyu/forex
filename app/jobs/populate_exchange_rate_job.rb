class PopulateExchangeRateJob < ApplicationJob
  queue_as :populate_exchange_rate_job

  def perform(provider, id)
    ExchangeRateServices.new({provider: provider, action:'histories', favorite_exchange_rate_id: id}).call
  end

end
