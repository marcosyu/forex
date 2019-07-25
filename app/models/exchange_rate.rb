class ExchangeRate < ApplicationRecord
  belongs_to :user
  validates :amount, :base_currency, :target_currency, presence: true
  serialize :historical_duration, Hash

  after_save :pull_history

  def pull_history
    ExchangeRateServices.new(self.id).get_histories
  end
end
