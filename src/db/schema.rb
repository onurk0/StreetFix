# Onur Kose - S26-OK-StreetFix
# Reporting infrastructure problems to raise awareness
# Filename: schema.rb
# Description: auto-generated schema for the application
# last modified: April 15, 2026
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

ActiveRecord::Schema[8.1].define(version: 2026_04_16_021552) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "app_configs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "logo_url"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "reports", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "date_reported"
    t.text "description", null: false
    t.string "image_url"
    t.string "location", null: false
    t.integer "report_type", default: 0, null: false
    t.string "status", default: "open"
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_reports_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "admin", default: false
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at", precision: nil
    t.datetime "reset_password_sent_at", precision: nil
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "report_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["report_id"], name: "index_votes_on_report_id"
    t.index ["user_id", "report_id"], name: "index_votes_on_user_id_and_report_id", unique: true
    t.index ["user_id"], name: "index_votes_on_user_id"
  end

  add_foreign_key "reports", "users"
  add_foreign_key "votes", "reports"
  add_foreign_key "votes", "users"
end
