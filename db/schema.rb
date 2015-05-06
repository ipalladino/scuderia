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

ActiveRecord::Schema.define(:version => 20150506073028) do

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

  create_table "bookmarks", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "model_type_id"
    t.integer  "model_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "bookmarktypes", :force => true do |t|
    t.string   "model"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "car_models", :force => true do |t|
    t.string   "car_model"
    t.integer  "year_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.string   "designation"
    t.string   "msrp"
    t.string   "total_production"
    t.string   "engine_designer"
    t.string   "engine_configuration"
    t.string   "number_of_cylinders"
    t.string   "engine_location"
    t.string   "cylinder_bore"
    t.string   "stroke"
    t.string   "displacement"
    t.string   "engine_material"
    t.string   "compression_ratio"
    t.string   "horse_power"
    t.string   "torque"
    t.string   "redline"
    t.string   "timing"
    t.string   "fuel_delivery"
    t.string   "lubrication"
    t.string   "body_designer"
    t.string   "seating"
    t.string   "body_material"
    t.string   "chassis_construction"
    t.string   "overall_length"
    t.string   "overall_width"
    t.string   "height"
    t.string   "wheelbase"
    t.string   "steering"
    t.string   "fuel_capacity"
    t.string   "wheel_type"
    t.string   "wheel_size_front"
    t.string   "wheel_size_rear"
    t.string   "tire_size_front"
    t.string   "tire_size_rear"
    t.string   "tire_type"
    t.string   "front_brakes"
    t.string   "front_rotor_dimension"
    t.string   "rear_brakes"
    t.string   "rear_rotor_dimension"
    t.string   "drive_type"
    t.string   "gear_box"
    t.string   "clutch"
    t.string   "differential"
    t.string   "first_gear_ratio"
    t.string   "second_gear_ratio"
    t.string   "third_gear_ratio"
    t.string   "foruth_gear_ratio"
    t.string   "fifth_gear_ratio"
    t.string   "final_drive_ratio"
    t.string   "zero_sixty"
    t.string   "zero_hundred"
    t.string   "one_fourth_mile"
    t.string   "top_speed"
    t.string   "fuel_consumption"
  end

  add_index "car_models", ["year_id", "created_at"], :name => "index_car_models_on_year_id_and_created_at"
  add_index "car_models", ["year_id"], :name => "index_car_models_on_year_id"

  create_table "conversations", :force => true do |t|
    t.string   "subject",    :default => ""
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "engines", :force => true do |t|
    t.string   "name"
    t.integer  "car_model_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "ferraris", :force => true do |t|
    t.integer  "year_id"
    t.integer  "engine_id"
    t.integer  "transmission_id"
    t.integer  "trim_id"
    t.integer  "car_model_id"
    t.string   "title"
    t.text     "description"
    t.integer  "mileage"
    t.float    "price"
    t.string   "color"
    t.string   "interior_color"
    t.string   "vin"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.integer  "user_id"
    t.boolean  "published",       :default => false
    t.date     "published_at"
    t.datetime "publish_date"
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

  create_table "notifications", :force => true do |t|
    t.string   "type"
    t.text     "body"
    t.string   "subject",              :default => ""
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "conversation_id"
    t.boolean  "draft",                :default => false
    t.datetime "updated_at",                              :null => false
    t.datetime "created_at",                              :null => false
    t.integer  "notified_object_id"
    t.string   "notified_object_type"
    t.string   "notification_code"
    t.string   "attachment"
    t.boolean  "global",               :default => false
    t.datetime "expires"
  end

  add_index "notifications", ["conversation_id"], :name => "index_notifications_on_conversation_id"

  create_table "order_transactions", :force => true do |t|
    t.integer  "order_id"
    t.string   "action"
    t.integer  "amount"
    t.boolean  "success"
    t.string   "authorization"
    t.string   "message"
    t.text     "params"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "orders", :force => true do |t|
    t.string   "new"
    t.integer  "ferrari_id"
    t.string   "ip_address"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "card_type"
    t.date     "card_expires_on"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "publish_setting"
    t.integer  "promo_code_id"
  end

  create_table "promo_codes", :force => true do |t|
    t.string   "code"
    t.integer  "charges"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "promo_codes", ["code"], :name => "index_promo_codes_on_code", :unique => true

  create_table "receipts", :force => true do |t|
    t.integer  "receiver_id"
    t.string   "receiver_type"
    t.integer  "notification_id",                                  :null => false
    t.boolean  "is_read",                       :default => false
    t.boolean  "trashed",                       :default => false
    t.boolean  "deleted",                       :default => false
    t.string   "mailbox_type",    :limit => 25
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
  end

  add_index "receipts", ["notification_id"], :name => "index_receipts_on_notification_id"

  create_table "relationships", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "relationships", ["followed_id"], :name => "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], :name => "index_relationships_on_follower_id_and_followed_id", :unique => true
  add_index "relationships", ["follower_id"], :name => "index_relationships_on_follower_id"

  create_table "saved_searches", :force => true do |t|
    t.integer  "user_id"
    t.string   "year_fr"
    t.string   "year_to"
    t.string   "car_model"
    t.string   "keywords"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.boolean  "notify_me"
    t.float    "price_to",   :default => -1.0
    t.float    "price_fr",   :default => -1.0
  end

  add_index "saved_searches", ["user_id"], :name => "index_saved_searches_on_user_id"

  create_table "transmissions", :force => true do |t|
    t.string   "name"
    t.integer  "car_model_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",            :default => false
    t.string   "address"
    t.string   "state"
    t.string   "phone"
    t.string   "zip"
    t.boolean  "is_dealer"
    t.boolean  "public_email",     :default => false
    t.boolean  "public_address",   :default => false
    t.boolean  "public_phone",     :default => false
    t.boolean  "public_dealer",    :default => false
    t.string   "uid"
    t.string   "oauth_token"
    t.string   "provider"
    t.datetime "oauth_expires_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

  create_table "years", :force => true do |t|
    t.string   "car_year"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_foreign_key "notifications", "conversations", name: "notifications_on_conversation_id"

  add_foreign_key "receipts", "notifications", name: "receipts_on_notification_id"

end
