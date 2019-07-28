class PopulateExchangeRateJob < ApplicationJob
  @queue = :populate_exchange_rate_job

  def perform(provider, id)
    ExchangeRateServices.new({provider: provider, action:'histories', exchange_rate_id: id}).call
  end

end
