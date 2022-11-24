class CreateApiKeys < ActiveRecord::Migration[7.0]
  def change
    create_table :api_keys do |t|
      t.string :access_token, null: false, index: true
      t.datetime :expires_at, null: false
      t.references :user, null: false, foreign_key: true
      t.boolean :active, null: false

      t.timestamps
    end
  end
end
