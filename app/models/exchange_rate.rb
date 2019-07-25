class ExchangeRate < ApplicationRecord
  belongs_to :user
  validates :amount, :base_currency, :target_currency, presence: true
  serialize :historical_duration, Hash
end
