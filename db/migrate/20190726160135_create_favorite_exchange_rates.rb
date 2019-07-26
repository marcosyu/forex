class CreateFavoriteExchangeRates < ActiveRecord::Migration[5.2]
  def change
    create_table :favorite_exchange_rates do |t|
      t.string :base_currency, limit: 3
      t.string :target_currency, limit: 3
      t.decimal :amount, precision: 8, scale: 2
      t.timestamps
    end
    add_reference :favorite_exchange_rates, :user, foreign_key: true, index: true
  end
end
