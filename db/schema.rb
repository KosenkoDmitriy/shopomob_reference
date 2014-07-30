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

ActiveRecord::Schema.define(version: 20140730180545) do

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true

  create_table "banners", force: true do |t|
    t.string   "title"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "shop_id"
  end

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id",  default: 0, null: false
    t.integer  "_id"
  end

  add_index "categories", ["parent_id"], name: "index_categories_on_parent_id"

  create_table "categories_category_items", id: false, force: true do |t|
    t.integer "category_id"
    t.integer "category_item_id"
  end

  create_table "categories_shops", force: true do |t|
    t.integer  "category_id"
    t.integer  "shop_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "category_items", force: true do |t|
    t.integer  "parent_id",  default: 0, null: false
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "_id"
  end

  add_index "category_items", ["parent_id"], name: "index_category_items_on_parent_id"

  create_table "category_items_shops", force: true do |t|
    t.integer  "shop_id"
    t.integer  "category_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_items", force: true do |t|
    t.string   "department"
    t.string   "value"
    t.integer  "contact_type_id"
    t.integer  "shop_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "fio"
  end

  add_index "contact_items", ["contact_type_id"], name: "index_contact_items_on_contact_type_id"
  add_index "contact_items", ["shop_id"], name: "index_contact_items_on_shop_id"

  create_table "contact_types", force: true do |t|
    t.string   "name"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "path"
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "services", force: true do |t|
    t.string   "title"
    t.string   "url"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shops", force: true do |t|
    t.string   "name"
    t.string   "domain"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.integer  "postal_code"
    t.string   "address"
    t.string   "time_work"
    t.string   "email"
    t.string   "www"
    t.integer  "favorite",    default: 0, null: false
    t.integer  "rated",       default: 0, null: false
    t.integer  "_id"
    t.string   "tags"
    t.text     "description"
  end

  add_index "shops", ["parent_id"], name: "index_shops_on_parent_id"

end
