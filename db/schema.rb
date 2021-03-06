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

ActiveRecord::Schema.define(version: 20160814094627) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "pivotal_tracker_stories", force: :cascade do |t|
    t.string   "tracker_id"
    t.string   "name"
    t.json     "data",             default: {}
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.text     "pt_owner_ids",     default: [],              array: true
    t.text     "pull_request_nos", default: [],              array: true
    t.string   "state"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "pt_id"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.boolean  "enabled",                default: false
    t.text     "roles",                  default: [],                 array: true
    t.string   "personal_slack_webhook"
    t.string   "slack_username"
  end

end
