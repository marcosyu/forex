class ModifyDecimalFields < ActiveRecord::Migration[5.2]
  def up
    change_column :exchange_rates, :rate, :decimal, precision: 5, scale: 4
  end

  def down
    change_column :exchange_rates, :rate, :decimal, precision: 8, scale: 2
  end

end
