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

ActiveRecord::Schema[7.1].define(version: 2025_02_07_013746) do
  create_table "users", charset: "utf8mb3", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "first_name", null: false
    t.string "first_name_furigana", null: false
    t.string "last_name", null: false
    t.string "last_name_furigana", null: false
    t.date "birthday", null: false
    t.string "blood_type", null: false
    t.string "address", null: false
    t.string "phone_number", null: false
    t.string "uuid", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["phone_number"], name: "index_users_on_phone_number", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uuid"], name: "index_users_on_uuid", unique: true
  end

  create_table "view_accesses", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "parent_id", null: false
    t.string "public_page_url"
    t.datetime "last_accessed_at"
    t.integer "access_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_view_accesses_on_parent_id"
    t.index ["user_id"], name: "index_view_accesses_on_user_id"
  end

  create_table "view_permissions", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "first_name", null: false
    t.string "first_name_furigana", null: false
    t.string "last_name", null: false
    t.string "last_name_furigana", null: false
    t.date "birthday", null: false
    t.string "blood_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_view_permissions_on_user_id"
  end

  create_table "view_requests", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "parent_id", null: false
    t.string "first_name", null: false
    t.string "first_name_furigana", null: false
    t.string "last_name", null: false
    t.string "last_name_furigana", null: false
    t.date "birthday", null: false
    t.string "blood_type", null: false
    t.string "relationship", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "fk_rails_765025e491"
    t.index ["user_id"], name: "index_view_requests_on_user_id"
  end

  add_foreign_key "view_accesses", "users"
  add_foreign_key "view_accesses", "users", column: "parent_id"
  add_foreign_key "view_permissions", "users"
  add_foreign_key "view_requests", "users"
  add_foreign_key "view_requests", "users", column: "parent_id"
end
