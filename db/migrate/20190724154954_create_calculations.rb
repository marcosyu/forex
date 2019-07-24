class CreateCalculations < ActiveRecord::Migration[5.2]
  def change
    create_table :calculations do |t|
      t.decimal :value, precision: 8, scale: 2
      t.string :from, limit: 3
      t.string :to, limit: 3
      t.decimal :converted_value, precision: 8, scale: 2
      t.timestamps
    end
  end
end
