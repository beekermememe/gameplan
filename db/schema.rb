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

ActiveRecord::Schema.define(version: 20171104175114) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "courts", force: :cascade do |t|
    t.string "name"
    t.text "address"
    t.string "longitude"
    t.string "latitude"
    t.string "summary"
    t.string "google_map_link"
    t.string "phone"
    t.integer "indoorcourts"
    t.integer "outdoorcourts"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "match_details", force: :cascade do |t|
    t.string "strengths", default: [], array: true
    t.string "strength_ids", default: [], array: true
    t.string "weaknesses", default: [], array: true
    t.string "weakness_ids", default: [], array: true
    t.integer "result_id"
    t.text "details"
    t.text "note_to_self"
    t.datetime "played_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "matches", force: :cascade do |t|
    t.integer "court_id"
    t.integer "court_number"
    t.integer "user_id"
    t.integer "opponent_id"
    t.integer "match_detail_id"
    t.datetime "match_datetime"
    t.integer "timezone"
    t.integer "league_id"
    t.text "result_summary"
    t.text "location_summary"
    t.text "opponent_summary"
    t.boolean "doubles"
    t.boolean "singles"
    t.integer "partner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "results", force: :cascade do |t|
    t.string "sets", default: [], array: true
    t.integer "match_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "strengths", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "club"
    t.integer "club_id"
    t.string "usta_number"
    t.string "city"
    t.string "state"
    t.string "zipcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "weaknesses", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
