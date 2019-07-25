class AddUserReferenceToExchangeRates < ActiveRecord::Migration[5.2]
  def change

    add_reference :exchange_rates, :user, foreign_key: true, index: true
  end
end
