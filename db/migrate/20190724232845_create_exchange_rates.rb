class CreateExchangeRates < ActiveRecord::Migration[5.2]
  def change
    create_table :exchange_rates do |t|
      t.decimal :amount, precision: 8, scale: 2
      t.string :base_currency, limit: 3
      t.string :target_currency, limit: 3
      t.text :historical_duration

      t.timestamps
    end
  end
end
