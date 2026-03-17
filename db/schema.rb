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

ActiveRecord::Schema[8.0].define(version: 2026_03_17_112837) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.text "description"
    t.bigint "parent_id"
    t.integer "position", default: 0
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_id"], name: "index_categories_on_parent_id"
    t.index ["position"], name: "index_categories_on_position"
    t.index ["slug"], name: "index_categories_on_slug", unique: true
  end

  create_table "option_types", force: :cascade do |t|
    t.string "name", null: false
    t.string "presentation", null: false
    t.integer "position", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "option_value_variants", force: :cascade do |t|
    t.bigint "variant_id", null: false
    t.bigint "option_value_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["option_value_id"], name: "index_option_value_variants_on_option_value_id"
    t.index ["variant_id", "option_value_id"], name: "index_option_value_variants_on_variant_id_and_option_value_id", unique: true
    t.index ["variant_id"], name: "index_option_value_variants_on_variant_id"
  end

  create_table "option_values", force: :cascade do |t|
    t.bigint "option_type_id", null: false
    t.string "name", null: false
    t.string "presentation", null: false
    t.integer "position", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["option_type_id"], name: "index_option_values_on_option_type_id"
  end

  create_table "product_option_types", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "option_type_id", null: false
    t.integer "position", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["option_type_id"], name: "index_product_option_types_on_option_type_id"
    t.index ["product_id", "option_type_id"], name: "index_product_option_types_on_product_id_and_option_type_id", unique: true
    t.index ["product_id"], name: "index_product_option_types_on_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.text "description"
    t.string "status", default: "draft", null: false
    t.bigint "category_id"
    t.string "meta_title"
    t.text "meta_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["slug"], name: "index_products_on_slug", unique: true
    t.index ["status"], name: "index_products_on_status"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "stock_items", force: :cascade do |t|
    t.bigint "stock_location_id", null: false
    t.bigint "variant_id", null: false
    t.integer "available_quantity", default: 0, null: false
    t.integer "reserved_quantity", default: 0, null: false
    t.boolean "backorderable", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stock_location_id", "variant_id"], name: "index_stock_items_on_stock_location_id_and_variant_id", unique: true
    t.index ["stock_location_id"], name: "index_stock_items_on_stock_location_id"
    t.index ["variant_id"], name: "index_stock_items_on_variant_id"
  end

  create_table "stock_locations", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "active", default: true
    t.boolean "default", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "role", default: "customer", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  create_table "variants", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.string "sku"
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "USD", null: false
    t.integer "compare_at_price_cents"
    t.integer "cost_price_cents"
    t.decimal "weight", precision: 10, scale: 2
    t.decimal "width", precision: 10, scale: 2
    t.decimal "height", precision: 10, scale: 2
    t.decimal "depth", precision: 10, scale: 2
    t.boolean "is_master", default: false
    t.integer "position", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_variants_on_product_id"
    t.index ["sku"], name: "index_variants_on_sku", unique: true, where: "(sku IS NOT NULL)"
  end

  add_foreign_key "option_value_variants", "option_values"
  add_foreign_key "option_value_variants", "variants"
  add_foreign_key "option_values", "option_types"
  add_foreign_key "product_option_types", "option_types"
  add_foreign_key "product_option_types", "products"
  add_foreign_key "products", "categories"
  add_foreign_key "sessions", "users"
  add_foreign_key "stock_items", "stock_locations"
  add_foreign_key "stock_items", "variants"
  add_foreign_key "variants", "products"
end
