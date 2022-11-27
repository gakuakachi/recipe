# frozen_string_literal: true

class AddUniqueIndexToRates < ActiveRecord::Migration[7.0]
  def change
    add_index :rates, %i[user_id recipe_id], unique: true
  end
end
