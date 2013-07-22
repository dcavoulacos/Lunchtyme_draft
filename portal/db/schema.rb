# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20130722214630) do

  create_table "matchings", force: true do |t|
    t.integer  "user_id"
    t.integer  "match_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
  end

  add_index "matchings", ["user_id", "match_id"], name: "index_matchings_on_user_id_and_match_id"

  create_table "schedules", force: true do |t|
    t.integer  "user_id"
    t.string   "day"
    t.string   "start_time"
    t.string   "end_time"
    t.string   "location"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "schedules", ["user_id"], name: "index_schedules_on_user_id"

  create_table "users", force: true do |t|
    t.string   "name"
    t.integer  "class_year"
    t.string   "res_college"
    t.string   "email"
    t.string   "phone"
    t.string   "gender"
    t.integer  "facebook_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.text     "friends",          limit: 255
    t.string   "netid"
    t.string   "first_name"
    t.string   "last_name"
    t.text     "objectm"
  end

end
