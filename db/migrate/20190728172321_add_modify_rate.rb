class AddModifyRate < ActiveRecord::Migration[5.2]
  def up
    change_column :exchange_rates, :rate, :decimal, precision: 9, scale: 6
  end
  def down
    change_column :exchange_rates, :rate, :decimal, precision: 8, scale: 2
  end
end
