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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20131024082130) do

  create_table "assets", :force => true do |t|
    t.integer  "ferrari_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.string   "imageable_type"
    t.integer  "imageable_id"
  end

  create_table "blogs", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.integer  "user_id"
    t.integer  "blogtype"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "blogs", ["user_id"], :name => "index_blogs_on_user_id"

  create_table "car_models", :force => true do |t|
    t.string   "car_model"
    t.integer  "year_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "car_models", ["year_id", "created_at"], :name => "index_car_models_on_year_id_and_created_at"
  add_index "car_models", ["year_id"], :name => "index_car_models_on_year_id"

  create_table "engines", :force => true do |t|
    t.string   "name"
    t.integer  "car_model_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "ferrari_images", :force => true do |t|
    t.string   "caption"
    t.integer  "ferrari_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "ferraris", :force => true do |t|
    t.integer  "year_id"
    t.integer  "engine_id"
    t.integer  "transmission_id"
    t.integer  "trim_id"
    t.integer  "car_model_id"
    t.string   "title"
    t.string   "description"
    t.integer  "mileage"
    t.float    "price"
    t.string   "color"
    t.string   "interior_color"
    t.string   "vin"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "user_id"
  end

  add_index "ferraris", ["user_id"], :name => "index_ferraris_on_user_id"
  add_index "ferraris", ["year_id", "car_model_id", "engine_id"], :name => "index_ferraris_on_year_id_and_car_model_id_and_engine_id"

  create_table "generic_images", :force => true do |t|
    t.string   "caption"
    t.integer  "car_model_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
  end

  create_table "microposts", :force => true do |t|
    t.string   "content"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "microposts", ["user_id", "created_at"], :name => "index_microposts_on_user_id_and_created_at"

  create_table "relationships", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "relationships", ["followed_id"], :name => "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], :name => "index_relationships_on_follower_id_and_followed_id", :unique => true
  add_index "relationships", ["follower_id"], :name => "index_relationships_on_follower_id"

  create_table "transmissions", :force => true do |t|
    t.string   "name"
    t.integer  "car_model_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "trims", :force => true do |t|
    t.string   "car_trim"
    t.integer  "car_model_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           :default => false
    t.string   "address"
    t.string   "state"
    t.string   "phone"
    t.string   "zip"
    t.boolean  "is_dealer"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

  create_table "years", :force => true do |t|
    t.string   "car_year"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
