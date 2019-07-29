class AddPrescisionToRate < ActiveRecord::Migration[5.2]
  def up
    change_column :exchange_rates, :rate, :decimal, precision: 10, scale: 6
  end
  def down
    change_column :exchange_rates, :rate, :decimal, precision: 9, scale: 6
  end
end
