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

ActiveRecord::Schema.define(version: 20150524082314) do

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

  create_table "copies", force: :cascade do |t|
    t.text     "questions"
    t.text     "answers"
    t.text     "squares_xy"
    t.integer  "student_id"
    t.integer  "student_group_id"
    t.integer  "samples_nr"
    t.integer  "generated_quiz_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.float    "mark"
  end

  add_index "copies", ["generated_quiz_id"], name: "index_copies_on_generated_quiz_id"

  create_table "courses", force: :cascade do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "courses", ["user_id"], name: "index_courses_on_user_id"

  create_table "courses_student_groups", id: false, force: :cascade do |t|
    t.integer "course_id"
    t.integer "student_group_id"
  end

  add_index "courses_student_groups", ["course_id"], name: "index_courses_student_groups_on_course_id"
  add_index "courses_student_groups", ["student_group_id"], name: "index_courses_student_groups_on_student_group_id"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "generated_quizzes", force: :cascade do |t|
    t.integer  "course_id"
    t.integer  "quiz_id"
    t.integer  "copies_nr"
    t.boolean  "random_opt"
    t.text     "student_group_ids"
    t.integer  "questions_nr"
    t.integer  "versions_nr"
    t.text     "question_groups_nrs"
    t.integer  "user_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "generated_quizzes", ["user_id"], name: "index_generated_quizzes_on_user_id"

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
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  add_index "questions", ["quiz_id"], name: "index_questions_on_quiz_id"

  create_table "quizzes", force: :cascade do |t|
    t.string   "name"
    t.integer  "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "quizzes", ["course_id"], name: "index_quizzes_on_course_id"

  create_table "scanned_quizzes", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "scan_file_name"
    t.string   "scan_content_type"
    t.integer  "scan_file_size"
    t.datetime "scan_updated_at"
  end

  add_index "scanned_quizzes", ["user_id"], name: "index_scanned_quizzes_on_user_id"

  create_table "student_groups", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "students", force: :cascade do |t|
    t.string   "name"
    t.string   "surname"
    t.integer  "student_group_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "students", ["student_group_id"], name: "index_students_on_student_group_id"

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
