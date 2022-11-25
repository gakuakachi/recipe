class CreateRates < ActiveRecord::Migration[7.0]
  def change
    create_table :rates do |t|
      t.string :uuid, null: false, index: { unique: true }
      t.references :user, foreign_key: true, index: true
      t.references :recipe, foreign_key: true, index: true
      t.float :value, null: false
      
      t.timestamps
    end
  end
end
