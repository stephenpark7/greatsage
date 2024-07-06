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

ActiveRecord::Schema[7.1].define(version: 2024_06_04_195542) do
  create_table "access_tokens", force: :cascade do |t|
    t.string "jti", null: false
    t.integer "user_id"
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_access_tokens_on_jti", unique: true
    t.index ["user_id"], name: "index_access_tokens_on_user_id"
  end

  create_table "refresh_tokens", force: :cascade do |t|
    t.string "jti", null: false
    t.integer "user_id"
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_refresh_tokens_on_jti", unique: true
    t.index ["user_id"], name: "index_refresh_tokens_on_user_id"
  end

  create_table "revoked_tokens", force: :cascade do |t|
    t.string "jti", null: false
    t.integer "user_id"
    t.datetime "expires_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["jti"], name: "index_revoked_tokens_on_jti", unique: true
    t.index ["user_id"], name: "index_revoked_tokens_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.boolean "completed"
    t.integer "todo_list_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["todo_list_id"], name: "index_tasks_on_todo_list_id"
  end

  create_table "todo_lists", force: :cascade do |t|
    t.string "title"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_todo_lists_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "recovery_password_digest"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "access_tokens", "users"
  add_foreign_key "refresh_tokens", "users"
  add_foreign_key "revoked_tokens", "users"
  add_foreign_key "tasks", "todo_lists"
  add_foreign_key "todo_lists", "users"
end
