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

ActiveRecord::Schema[7.1].define(version: 2024_01_22_111623) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "items", force: :cascade do |t|
    t.bigint "admin_id", null: false
    t.string "name"
    t.text "description"
    t.string "city"
    t.decimal "finance_fee", precision: 10, scale: 2
    t.decimal "option_to_purchase_fee", precision: 10, scale: 2
    t.decimal "total_amount_payable", precision: 10, scale: 2
    t.integer "duration"
    t.decimal "apr_representative", precision: 5, scale: 2
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_items_on_admin_id"
  end

  create_table "reservation_items", force: :cascade do |t|
    t.bigint "reservation_id", null: false
    t.bigint "item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_reservation_items_on_item_id"
    t.index ["reservation_id"], name: "index_reservation_items_on_reservation_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.date "reserve_for_use_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_reservations_on_customer_id"
    t.index ["reserve_for_use_date"], name: "index_reservations_on_reserve_for_use_date"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "city"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "jti", null: false
    t.boolean "admin", default: false
    t.boolean "super_admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "items", "users", column: "admin_id"
  add_foreign_key "reservation_items", "items"
  add_foreign_key "reservation_items", "reservations"
  add_foreign_key "reservations", "users", column: "customer_id"
end
