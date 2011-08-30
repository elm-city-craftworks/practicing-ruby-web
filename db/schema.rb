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

ActiveRecord::Schema.define(:version => 20110830041617) do

  create_table "articles", :force => true do |t|
    t.text     "subject"
    t.text     "body"
    t.text     "status",                :default => "draft"
    t.text     "mailchimp_campaign_id"
    t.datetime "published_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authorization_links", :force => true do |t|
    t.text     "mailchimp_email"
    t.text     "github_nickname"
    t.text     "secret"
    t.integer  "authorization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authorizations", :force => true do |t|
    t.text     "github_uid"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.text     "first_name"
    t.text     "last_name"
    t.text     "email"
    t.text     "mailchimp_web_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "github_nickname"
    t.boolean  "admin",            :default => false
  end

end
