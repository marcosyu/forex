class AddCalculationsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_reference :calculations, :user, index: true, foreign_key: true
  end
end
