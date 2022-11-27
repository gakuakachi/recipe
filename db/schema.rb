# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_11_27_095622) do
  create_table "api_keys", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "access_token", null: false
    t.datetime "expires_at", null: false
    t.bigint "user_id", null: false
    t.boolean "active", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["access_token"], name: "index_api_keys_on_access_token"
    t.index ["user_id"], name: "index_api_keys_on_user_id"
  end

  create_table "rates", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "uuid", null: false
    t.bigint "user_id"
    t.bigint "recipe_id"
    t.float "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipe_id"], name: "index_rates_on_recipe_id"
    t.index ["user_id", "recipe_id"], name: "index_rates_on_user_id_and_recipe_id", unique: true
    t.index ["user_id"], name: "index_rates_on_user_id"
    t.index ["uuid"], name: "index_rates_on_uuid", unique: true
  end

  create_table "recipes", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "uuid", null: false
    t.bigint "user_id", null: false
    t.text "description", null: false
    t.text "ingredients", null: false
    t.text "steps", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_recipes_on_user_id"
    t.index ["uuid"], name: "index_recipes_on_uuid", unique: true
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "uuid", null: false
    t.string "email", null: false
    t.string "crypted_password", null: false
    t.string "salt", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["uuid"], name: "index_users_on_uuid", unique: true
  end

  add_foreign_key "api_keys", "users"
  add_foreign_key "rates", "recipes"
  add_foreign_key "rates", "users"
  add_foreign_key "recipes", "users"
end
