class AddUniqueIndexToRates < ActiveRecord::Migration[7.0]
  def change
    add_index :rates, [:user_id, :recipe_id], unique: true
  end
end
