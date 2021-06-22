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

ActiveRecord::Schema.define(version: 2021_05_25_020928) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "chart_preferences", force: :cascade do |t|
    t.string "table_name"
    t.boolean "hide_table"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_chart_preferences_on_user_id"
  end

  create_table "csv_uploads", force: :cascade do |t|
    t.integer "source_id"
    t.boolean "uploaded", default: false
    t.date "csv_upload_date"
    t.string "logstash_path"
    t.string "logstash_column", array: true
    t.string "logstash_host"
    t.string "logstash_index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "data_dictionaries", force: :cascade do |t|
    t.integer "user_id"
    t.integer "forescout_id"
    t.integer "source_id"
    t.integer "admin_id"
    t.string "csv_header_name"
    t.string "maps_to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "data_dump_dictionaries", force: :cascade do |t|
    t.integer "user_id"
    t.integer "source_id"
    t.integer "policy_id"
    t.integer "forescout_id"
    t.string "csv_header_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "data_dump_tables", force: :cascade do |t|
    t.integer "data_dump_dictionary_id"
    t.string "csv_header_name"
    t.string "csv_row_value"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "elastic_policies", force: :cascade do |t|
    t.string "title"
    t.string "source"
    t.json "policy_output"
    t.json "input_requirements"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "elastic_reports", force: :cascade do |t|
    t.datetime "data_creation_date"
    t.string "report_type_title"
    t.string "report_value_title"
    t.string "elastic_id"
    t.bigint "source_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source_id"], name: "index_elastic_reports_on_source_id"
  end

  create_table "master_tables", force: :cascade do |t|
    t.string "field_one"
    t.string "field_two"
    t.string "field_three"
    t.string "field_four"
    t.string "field_five"
    t.string "field_six"
    t.string "field_seven"
    t.string "field_eight"
    t.string "field_nine"
    t.string "field_ten"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "report_types", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "report_values", force: :cascade do |t|
    t.string "title"
    t.integer "report_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sources", force: :cascade do |t|
    t.string "source_title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "table_entries", force: :cascade do |t|
    t.string "field_one"
    t.string "field_two"
    t.string "field_three"
    t.string "field_four"
    t.string "field_five"
    t.string "field_six"
    t.string "field_seven"
    t.string "field_eight"
    t.string "field_nine"
    t.string "field_ten"
    t.integer "user_id"
    t.date "csv_upload_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_colors", force: :cascade do |t|
    t.string "color"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_colors_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "role_id"
    t.integer "overlooking_user"
    t.string "user_first_name"
    t.string "user_last_name"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "chart_preferences", "users"
  add_foreign_key "user_colors", "users"
end
