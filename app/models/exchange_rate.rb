class ExchangeRate < ApplicationRecord

  validates :base_currency, :target_currency, :date, presence: true
  validates_uniqueness_of :date, scope: [:base_currency, :target_currency]

  validates :rate, presence: true

end
