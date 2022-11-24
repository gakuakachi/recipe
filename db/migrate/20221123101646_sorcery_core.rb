class SorceryCore < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :uuid, null: false, index: { unique: true }
      t.string :email,            null: false, index: { unique: true }
      t.string :crypted_password, null: false
      t.string :salt, null: false
      t.string :name, null: false

      t.timestamps                null: false
    end
  end
end
