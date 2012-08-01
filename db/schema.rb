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

ActiveRecord::Schema.define(:version => 20120801233245) do

  create_table "announcements", :force => true do |t|
    t.text     "title"
    t.text     "body"
    t.integer  "author_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "broadcast",         :default => false, :null => false
    t.text     "broadcast_message"
  end

  create_table "article_visits", :force => true do |t|
    t.integer  "user_id"
    t.integer  "article_id"
    t.integer  "views",      :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "articles", :force => true do |t|
    t.text     "subject"
    t.text     "body"
    t.text     "status",                :default => "draft"
    t.text     "mailchimp_campaign_id"
    t.datetime "published_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "issue_number"
    t.integer  "volume_id"
    t.integer  "collection_id"
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

  create_table "collections", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "image_file_name"
    t.string   "slug"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  create_table "comments", :force => true do |t|
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "queue"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "emails", :force => true do |t|
    t.string   "from_address",     :null => false
    t.text     "to_address"
    t.text     "cc_address"
    t.text     "bcc_address"
    t.text     "reply_to_address"
    t.text     "subject"
    t.text     "content"
    t.datetime "sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shared_articles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "article_id"
    t.text     "secret"
    t.integer  "views"
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
    t.boolean  "admin",                 :default => false
    t.boolean  "notify_conversations",  :default => true,  :null => false
    t.boolean  "notify_mentions",       :default => true,  :null => false
    t.boolean  "notify_comment_made",   :default => false, :null => false
    t.boolean  "beta_tester",           :default => false
    t.boolean  "account_disabled",      :default => false
    t.boolean  "notifications_enabled", :default => false, :null => false
  end

  create_table "volumes", :force => true do |t|
    t.integer  "number"
    t.text     "description"
    t.date     "start_date"
    t.date     "finish_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
