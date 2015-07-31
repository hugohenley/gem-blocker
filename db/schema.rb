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

ActiveRecord::Schema.define(version: 20150730042245) do

  create_table "blockedversions", force: :cascade do |t|
    t.string   "number",        limit: 255
    t.integer  "gemblocker_id", limit: 4
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "commits", force: :cascade do |t|
    t.string   "hash_id",           limit: 255
    t.string   "title",             limit: 255
    t.string   "author_name",       limit: 255
    t.string   "author_email",      limit: 255
    t.datetime "commit_created_at"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "project_id",        limit: 4
  end

  create_table "gemblockers", force: :cascade do |t|
    t.string   "gem",               limit: 255
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "verification_type", limit: 255
  end

  create_table "projects", force: :cascade do |t|
    t.string   "name",             limit: 255
    t.string   "ssh_url_to_repo",  limit: 255
    t.string   "http_url_to_repo", limit: 255
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "gitproject_id",    limit: 4
    t.string   "description",      limit: 255
    t.string   "server",           limit: 255
  end

  create_table "rubygems", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "description",     limit: 255
    t.string   "current_version", limit: 255
    t.string   "authors",         limit: 255
    t.string   "info",            limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "statuses", force: :cascade do |t|
    t.integer  "used_gem_id",     limit: 4
    t.string   "lock_type",       limit: 255
    t.string   "locked_versions", limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "used_gems", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "version",     limit: 255
    t.string   "description", limit: 255
    t.integer  "commit_id",   limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "diff",        limit: 255
  end

  create_table "versions", force: :cascade do |t|
    t.string   "number",      limit: 255
    t.string   "summary",     limit: 255
    t.string   "description", limit: 255
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "rubygem_id",  limit: 4
  end

end
