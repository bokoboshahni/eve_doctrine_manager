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

ActiveRecord::Schema[7.0].define(version: 2022_12_11_224804) do
  create_table "fitting_items", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "fitting_id", null: false
    t.bigint "item_id", null: false
    t.bigint "charge_id"
    t.string "location"
    t.boolean "offline"
    t.integer "position", null: false
    t.integer "quantity"
    t.string "section"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["charge_id"], name: "index_fitting_items_on_charge_id"
    t.index ["fitting_id"], name: "index_fitting_items_on_fitting_id"
    t.index ["item_id"], name: "index_fitting_items_on_item_id"
  end

  create_table "fittings", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "container_id"
    t.text "description"
    t.text "fitting_name", null: false
    t.boolean "published"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["container_id", "fitting_name"], name: "index_fittings_on_container_id_and_fitting_name", unique: true, using: :hash
  end

  create_table "item_categories", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.text "name", null: false
    t.boolean "published", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "item_groups", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "category_id", null: false
    t.text "name", null: false
    t.boolean "published", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_item_groups_on_category_id"
  end

  create_table "items", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.string "name", null: false
    t.boolean "published", null: false
    t.string "slot"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_items_on_group_id"
  end

end
