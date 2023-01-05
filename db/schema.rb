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

ActiveRecord::Schema[7.0].define(version: 2023_01_05_202913) do
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
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "added_to_waitlist_notifications", force: :cascade do |t|
    t.integer "item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_added_to_waitlist_notifications_on_item_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.string "category"
    t.string "location"
    t.text "description"
    t.integer "price_ct"
    t.integer "rental_duration_sec"
    t.datetime "rental_start", precision: nil
    t.text "return_checklist"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "owner"
    t.integer "holder"
    t.integer "lend_status", default: 0
    t.index ["holder"], name: "index_items_on_holder"
    t.index ["owner"], name: "index_items_on_owner"
  end

  create_table "lend_request_notifications", force: :cascade do |t|
    t.integer "borrower_id", null: false
    t.integer "item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["borrower_id"], name: "index_lend_request_notifications_on_borrower_id"
    t.index ["item_id"], name: "index_lend_request_notifications_on_item_id"
  end

  create_table "memberships", force: :cascade do |t|
    t.string "type"
    t.integer "group_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id", "user_id"], name: "index_memberships_on_group_id_and_user_id", unique: true
    t.index ["group_id"], name: "index_memberships_on_group_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "move_up_on_waitlist_notifications", force: :cascade do |t|
    t.integer "item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_move_up_on_waitlist_notifications_on_item_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.datetime "date"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "actable_type"
    t.integer "actable_id"
    t.index ["actable_type", "actable_id"], name: "index_notifications_on_actable"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "return_request_notifications", force: :cascade do |t|
    t.integer "borrower_id", null: false
    t.integer "item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["borrower_id"], name: "index_return_request_notifications_on_borrower_id"
    t.index ["item_id"], name: "index_return_request_notifications_on_item_id"
  end

  create_table "users", force: :cascade do |t|
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

  create_table "users_waitlists", id: false, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "waitlist_id", null: false
  end

  create_table "waitlists", force: :cascade do |t|
    t.integer "item_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_waitlists_on_item_id"
  end

  create_table "wishlist", id: false, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "item_id", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "added_to_waitlist_notifications", "items"
  add_foreign_key "items", "users", column: "holder"
  add_foreign_key "items", "users", column: "owner"
  add_foreign_key "lend_request_notifications", "items"
  add_foreign_key "lend_request_notifications", "users", column: "borrower_id"
  add_foreign_key "memberships", "groups"
  add_foreign_key "memberships", "users"
  add_foreign_key "move_up_on_waitlist_notifications", "items"
  add_foreign_key "notifications", "users"
  add_foreign_key "return_request_notifications", "items"
  add_foreign_key "return_request_notifications", "users", column: "borrower_id"
  add_foreign_key "waitlists", "items"
end
