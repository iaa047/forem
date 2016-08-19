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

ActiveRecord::Schema.define(version: 20160818215946) do

  create_table "forem_forums", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "permalink"
    t.string   "title"
    t.text     "description"
    t.integer  "state",       default: 0
    t.date     "deleted_at"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["permalink"], name: "index_forem_forums_on_permalink", unique: true
    t.index ["state"], name: "index_forem_forums_on_state"
    t.index ["user_id"], name: "index_forem_forums_on_user_id"
  end

  create_table "forem_posts", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "topic_id"
    t.integer  "reply_to_id"
    t.text     "body"
    t.integer  "state",       default: 0
    t.date     "deleted_at"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["reply_to_id"], name: "index_forem_posts_on_reply_to_id"
    t.index ["state"], name: "index_forem_posts_on_state"
    t.index ["topic_id"], name: "index_forem_posts_on_topic_id"
    t.index ["user_id"], name: "index_forem_posts_on_user_id"
  end

  create_table "forem_topics", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "forum_id"
    t.string   "permalink"
    t.string   "title"
    t.text     "description"
    t.integer  "state",       default: 0
    t.date     "deleted_at"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["forum_id"], name: "index_forem_topics_on_forum_id"
    t.index ["permalink", "forum_id"], name: "index_forem_topics_on_permalink_and_forum_id", unique: true
    t.index ["permalink"], name: "index_forem_topics_on_permalink"
    t.index ["state"], name: "index_forem_topics_on_state"
    t.index ["user_id"], name: "index_forem_topics_on_user_id"
  end

  create_table "forem_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
