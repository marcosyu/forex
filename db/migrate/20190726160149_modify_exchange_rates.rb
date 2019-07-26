class ModifyExchangeRates < ActiveRecord::Migration[5.2]

  def change
    remove_reference :exchange_rates, :user, foreign_key: true, index: true
    remove_column :exchange_rates, :historical_duration, :text

    add_column :exchange_rates, :date, :datetime

    add_index :exchange_rates, :date
    add_index :exchange_rates, :base_currency
    add_index :exchange_rates, :target_currency
    rename_column :exchange_rates, :amount, :rate
  end

end
