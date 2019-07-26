class FavoriteExchangeRate < ApplicationRecord

  belongs_to :user
  validates :base_currency, :target_currency, :amount, presence: true


  def rates
    ExchangeRate.where(base_currency: base_currency, target_currency: target_currency)
  end

end
