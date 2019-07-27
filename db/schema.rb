# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_07_26_160149) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "calculations", force: :cascade do |t|
    t.decimal "value", precision: 8, scale: 2
    t.string "from", limit: 3
    t.string "to", limit: 3
    t.decimal "converted_value", precision: 8, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_calculations_on_user_id"
  end

  create_table "exchange_rates", force: :cascade do |t|
    t.string "base_currency", limit: 3
    t.string "target_currency", limit: 3
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "rate", precision: 8, scale: 2
    t.datetime "date"
    t.index ["base_currency"], name: "index_exchange_rates_on_base_currency"
    t.index ["date"], name: "index_exchange_rates_on_date"
    t.index ["target_currency"], name: "index_exchange_rates_on_target_currency"
  end

  create_table "favorite_exchange_rates", force: :cascade do |t|
    t.string "base_currency", limit: 3
    t.string "target_currency", limit: 3
    t.decimal "amount", precision: 8, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_favorite_exchange_rates_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.string "token"
    t.integer "expires_at"
    t.boolean "expires"
    t.string "refresh_token"
  end

  add_foreign_key "calculations", "users"
  add_foreign_key "favorite_exchange_rates", "users"
end
