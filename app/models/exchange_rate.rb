class ExchangeRate < ApplicationRecord
  belongs_to :user
  validates :amount, :base_currency, :target_currency, presence: true
  serialize :historical_duration, Hash

  after_save :pull_history

  def pull_history
    ExchangeRateJob.perform_later(self.id)
  end
end
