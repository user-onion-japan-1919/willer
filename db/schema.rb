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

ActiveRecord::Schema[7.1].define(version: 2025_02_09_051552) do
  create_table "notes", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "type_1"
    t.string "type_2"
    t.string "type_3"
    t.string "type_4"
    t.string "type_5"
    t.string "issue_1"
    t.string "issue_2"
    t.string "issue_3"
    t.string "issue_4"
    t.string "issue_5"
    t.string "requirement_1"
    t.string "requirement_2"
    t.string "requirement_3"
    t.string "requirement_4"
    t.string "requirement_5"
    t.string "title_1"
    t.string "title_2"
    t.string "title_3"
    t.string "title_4"
    t.string "title_5"
    t.text "content_1"
    t.text "content_2"
    t.text "content_3"
    t.text "content_4"
    t.text "content_5"
    t.json "metadata"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

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
    t.index ["first_name", "last_name", "first_name_furigana", "last_name_furigana", "birthday", "blood_type"], name: "index_users_on_unique_personal_info", unique: true, length: { first_name: 100, last_name: 100, first_name_furigana: 100, last_name_furigana: 100, blood_type: 10 }
    t.index ["phone_number"], name: "index_users_on_phone_number", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uuid"], name: "index_users_on_uuid", unique: true
  end

  create_table "view_accesses", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "owner_id", null: false
    t.bigint "viewer_id", null: false
    t.string "public_page_url"
    t.datetime "last_accessed_at"
    t.integer "access_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id", "viewer_id"], name: "index_view_accesses_on_owner_id_and_viewer_id", unique: true
    t.index ["owner_id"], name: "index_view_accesses_on_owner_id"
    t.index ["viewer_id"], name: "index_view_accesses_on_viewer_id"
  end

  create_table "view_permissions", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "owner_id", null: false
    t.bigint "viewer_id"
    t.string "first_name", null: false
    t.string "first_name_furigana", null: false
    t.string "last_name", null: false
    t.string "last_name_furigana", null: false
    t.date "birthday", null: false
    t.string "blood_type", null: false
    t.string "on_mode", default: "許可", null: false
    t.integer "on_timer_value", default: 1, null: false
    t.string "on_timer_unit", default: "day", null: false
    t.datetime "last_logout_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id", "viewer_id"], name: "index_view_permissions_on_owner_id_and_viewer_id", unique: true
    t.index ["owner_id"], name: "index_view_permissions_on_owner_id"
    t.index ["viewer_id"], name: "index_view_permissions_on_viewer_id"
  end

  create_table "view_requests", charset: "utf8mb3", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "first_name", null: false
    t.string "first_name_furigana", null: false
    t.string "last_name", null: false
    t.string "last_name_furigana", null: false
    t.date "birthday", null: false
    t.string "blood_type", null: false
    t.string "relationship", null: false
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_view_requests_on_user_id"
  end

  add_foreign_key "notes", "users"
  add_foreign_key "view_accesses", "users", column: "owner_id"
  add_foreign_key "view_accesses", "users", column: "viewer_id"
  add_foreign_key "view_permissions", "users", column: "owner_id"
  add_foreign_key "view_permissions", "users", column: "viewer_id"
  add_foreign_key "view_requests", "users"
end
