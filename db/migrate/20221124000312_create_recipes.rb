class CreateRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :recipes do |t|
      t.string :uuid, null: false, index: { unique: true }
      t.references :user, null: false, foreign_key: true, index: true
      t.text :description, null: false
      t.text :ingredients, null: false
      t.text :steps, null: false

      t.timestamps
    end
  end
end
