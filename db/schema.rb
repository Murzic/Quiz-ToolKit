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

ActiveRecord::Schema.define(version: 20150305145428) do

  create_table "answers", force: :cascade do |t|
    t.text     "name"
    t.binary   "image"
    t.boolean  "correct"
    t.integer  "question_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "answers", ["question_id"], name: "index_answers_on_question_id"

  create_table "courses", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "courses", ["user_id"], name: "index_courses_on_user_id"

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.integer  "quiz_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "groups", ["quiz_id"], name: "index_groups_on_quiz_id"

  create_table "groups_questions", id: false, force: :cascade do |t|
    t.integer "group_id"
    t.integer "question_id"
  end

  add_index "groups_questions", ["group_id"], name: "index_groups_questions_on_group_id"
  add_index "groups_questions", ["question_id"], name: "index_groups_questions_on_question_id"

  create_table "questions", force: :cascade do |t|
    t.text     "name"
    t.integer  "quiz_id"
    t.integer  "group_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "questions", ["group_id"], name: "index_questions_on_group_id"
  add_index "questions", ["quiz_id"], name: "index_questions_on_quiz_id"

  create_table "quizzes", force: :cascade do |t|
    t.string   "name"
    t.integer  "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "quizzes", ["course_id"], name: "index_quizzes_on_course_id"

  create_table "users", force: :cascade do |t|
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

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
