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

ActiveRecord::Schema.define(version: 20150407135059) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clients", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.string   "contact_name"
    t.string   "contact_email"
    t.string   "contact_phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.string   "registration_no"
    t.string   "tax_no"
  end

  create_table "image_sizes", force: true do |t|
    t.integer  "image_id"
    t.integer  "height"
    t.integer  "width"
    t.string   "source"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", force: true do |t|
    t.string   "od_id"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "project_id"
  end

  create_table "invoice_items", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.float    "price"
    t.string   "currency"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "invoice_id"
    t.string   "type"
  end

  create_table "invoices", force: true do |t|
    t.string   "number"
    t.integer  "invoice_year"
    t.integer  "invoice_count"
    t.date     "date"
    t.date     "due_date"
    t.date     "period_covered_from"
    t.date     "period_covered_to"
    t.float    "price"
    t.integer  "client_id"
    t.string   "client_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published"
    t.string   "currency"
    t.boolean  "credit_note",         default: false
  end

  create_table "projects", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "remember_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "od_token"
  end

end
