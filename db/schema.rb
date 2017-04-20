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

ActiveRecord::Schema.define(version: 20170420121609) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string   "uid"
    t.string   "name"
    t.string   "address"
    t.jsonb    "point"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "address_line_3"
    t.string   "town"
    t.string   "county"
    t.string   "postcode"
  end

  create_table "call_centres", force: :cascade do |t|
    t.string   "uid"
    t.string   "purpose"
    t.string   "twilio_number"
    t.string   "phone"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "guider_assignments", force: :cascade do |t|
    t.integer  "guider_id",   null: false
    t.integer  "location_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["guider_id", "location_id"], name: "index_guider_assignments_on_guider_id_and_location_id", unique: true, using: :btree
    t.index ["guider_id"], name: "index_guider_assignments_on_guider_id", using: :btree
    t.index ["location_id"], name: "index_guider_assignments_on_location_id", using: :btree
  end

  create_table "guiders", force: :cascade do |t|
    t.string   "name",       default: "", null: false
    t.string   "email",      default: "", null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string   "uid"
    t.string   "organisation"
    t.string   "title"
    t.string   "phone"
    t.string   "hours",                        limit: 500
    t.string   "state",                                    default: "pending"
    t.datetime "closed_at"
    t.integer  "version"
    t.jsonb    "raw"
    t.datetime "created_at",                                                   null: false
    t.datetime "updated_at",                                                   null: false
    t.boolean  "hidden",                                   default: false
    t.integer  "address_id"
    t.string   "booking_location_uid"
    t.integer  "editor_id"
    t.string   "twilio_number"
    t.string   "extension"
    t.string   "online_booking_twilio_number",             default: ""
    t.boolean  "online_booking_enabled",                   default: false
    t.date     "cut_off_from"
    t.string   "online_booking_reply_to",                  default: "",        null: false
    t.date     "cut_off_to"
    t.index ["booking_location_uid"], name: "index_locations_on_booking_location_uid", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "uid"
    t.string   "organisation_slug"
    t.string   "organisation_content_id"
    t.string   "permissions"
    t.boolean  "remotely_signed_out",     default: false
    t.boolean  "disabled",                default: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

end
