# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_09_22_134300) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "report_processes", force: :cascade do |t|
    t.string "uid", null: false
    t.bigint "user_id", null: false
    t.string "status", default: "queued", null: false
    t.integer "progress", default: 0, null: false
    t.string "file_path"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.text "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_report_processes_on_uid"
    t.index ["user_id"], name: "index_report_processes_on_user_id"
  end

  create_table "timer_registers", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "clock_in", null: false
    t.datetime "clock_out"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "idx_unique_open_time_register_per_user", unique: true, where: "(clock_out IS NULL)"
    t.index ["user_id"], name: "index_timer_registers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "report_processes", "users"
  add_foreign_key "timer_registers", "users"
end
