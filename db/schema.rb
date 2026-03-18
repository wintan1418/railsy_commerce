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

ActiveRecord::Schema[8.0].define(version: 2026_03_18_171405) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

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

  create_table "addresses", force: :cascade do |t|
    t.bigint "user_id"
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "address_line_1", null: false
    t.string "address_line_2"
    t.string "city", null: false
    t.string "state"
    t.string "postal_code", null: false
    t.string "country_code", default: "US", null: false
    t.string "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "cart_items", force: :cascade do |t|
    t.bigint "cart_id", null: false
    t.bigint "variant_id", null: false
    t.integer "quantity", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id", "variant_id"], name: "index_cart_items_on_cart_id_and_variant_id", unique: true
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
    t.index ["variant_id"], name: "index_cart_items_on_variant_id"
  end

  create_table "carts", force: :cascade do |t|
    t.string "token", null: false
    t.bigint "user_id"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_carts_on_token", unique: true
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

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

  create_table "discounts", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.string "discount_type", null: false
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.integer "minimum_order_cents"
    t.integer "usage_limit"
    t.integer "usage_count", default: 0, null: false
    t.integer "per_user_limit", default: 1
    t.datetime "starts_at"
    t.datetime "expires_at"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_discounts_on_code", unique: true
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

  create_table "order_events", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.string "event_type", null: false
    t.jsonb "data", default: {}
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.index ["event_type"], name: "index_order_events_on_event_type"
    t.index ["order_id"], name: "index_order_events_on_order_id"
    t.index ["user_id"], name: "index_order_events_on_user_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "variant_id", null: false
    t.integer "quantity", null: false
    t.integer "unit_price_cents", null: false
    t.integer "total_cents", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["variant_id"], name: "index_order_items_on_variant_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "number", null: false
    t.bigint "user_id"
    t.string "email", null: false
    t.string "status", default: "pending", null: false
    t.bigint "billing_address_id"
    t.bigint "shipping_address_id"
    t.integer "subtotal_cents", default: 0, null: false
    t.integer "shipping_total_cents", default: 0, null: false
    t.integer "tax_total_cents", default: 0, null: false
    t.integer "discount_total_cents", default: 0, null: false
    t.integer "total_cents", default: 0, null: false
    t.string "currency", default: "USD", null: false
    t.text "notes"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "discount_id"
    t.index ["discount_id"], name: "index_orders_on_discount_id"
    t.index ["number"], name: "index_orders_on_number", unique: true
    t.index ["status"], name: "index_orders_on_status"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "pages", force: :cascade do |t|
    t.string "title", null: false
    t.string "slug", null: false
    t.text "body"
    t.boolean "published", default: true
    t.integer "position", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_pages_on_slug", unique: true
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.integer "amount_cents", null: false
    t.string "currency", default: "USD", null: false
    t.string "status", default: "pending", null: false
    t.string "payment_method", null: false
    t.string "stripe_payment_intent_id"
    t.string "stripe_charge_id"
    t.jsonb "response_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_payments_on_order_id"
    t.index ["stripe_payment_intent_id"], name: "index_payments_on_stripe_payment_intent_id"
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

  create_table "product_relations", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "related_product_id", null: false
    t.string "relation_type", default: "related", null: false
    t.integer "position", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id", "related_product_id"], name: "index_product_relations_on_product_id_and_related_product_id", unique: true
    t.index ["product_id"], name: "index_product_relations_on_product_id"
    t.index ["related_product_id"], name: "index_product_relations_on_related_product_id"
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
    t.integer "reviews_count", default: 0, null: false
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["slug"], name: "index_products_on_slug", unique: true
    t.index ["status"], name: "index_products_on_status"
  end

  create_table "promotions", force: :cascade do |t|
    t.string "name", null: false
    t.string "promotion_type", null: false
    t.jsonb "conditions", default: {}
    t.boolean "active", default: true
    t.datetime "starts_at"
    t.datetime "expires_at"
    t.boolean "auto_apply", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_promotions_on_active"
    t.index ["promotion_type"], name: "index_promotions_on_promotion_type"
  end

  create_table "return_items", force: :cascade do |t|
    t.bigint "return_id", null: false
    t.bigint "order_item_id", null: false
    t.integer "quantity", null: false
    t.string "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_item_id"], name: "index_return_items_on_order_item_id"
    t.index ["return_id"], name: "index_return_items_on_return_id"
  end

  create_table "returns", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "user_id"
    t.string "status", default: "requested", null: false
    t.text "reason", null: false
    t.text "notes"
    t.integer "refund_amount_cents"
    t.string "currency", default: "USD"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_returns_on_order_id"
    t.index ["status"], name: "index_returns_on_status"
    t.index ["user_id"], name: "index_returns_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "user_id", null: false
    t.integer "rating", null: false
    t.string "title"
    t.text "body"
    t.string "status", default: "pending", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id", "user_id"], name: "index_reviews_on_product_id_and_user_id", unique: true
    t.index ["product_id"], name: "index_reviews_on_product_id"
    t.index ["status"], name: "index_reviews_on_status"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "ip_address"
    t.string "user_agent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "shipments", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "shipping_method_id", null: false
    t.string "tracking_number"
    t.string "status", default: "pending", null: false
    t.datetime "shipped_at"
    t.datetime "delivered_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_shipments_on_order_id"
    t.index ["shipping_method_id"], name: "index_shipments_on_shipping_method_id"
  end

  create_table "shipping_methods", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.integer "price_cents", default: 0, null: false
    t.string "currency", default: "USD", null: false
    t.integer "min_delivery_days"
    t.integer "max_delivery_days"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stock_items", force: :cascade do |t|
    t.bigint "stock_location_id", null: false
    t.bigint "variant_id", null: false
    t.integer "available_quantity", default: 0, null: false
    t.integer "reserved_quantity", default: 0, null: false
    t.boolean "backorderable", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "low_stock_threshold", default: 5
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

  create_table "store_configs", force: :cascade do |t|
    t.string "key", null: false
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_store_configs_on_key", unique: true
  end

  create_table "tax_rates", force: :cascade do |t|
    t.string "name", null: false
    t.decimal "rate", precision: 8, scale: 6, null: false
    t.string "country_code", null: false
    t.string "state"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_code", "state"], name: "index_tax_rates_on_country_code_and_state"
  end

  create_table "users", force: :cascade do |t|
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "role", default: "customer", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.string "avatar_url"
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["provider", "uid"], name: "index_users_on_provider_and_uid", unique: true
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

  create_table "wishlist_items", force: :cascade do |t|
    t.bigint "wishlist_id", null: false
    t.bigint "variant_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["variant_id"], name: "index_wishlist_items_on_variant_id"
    t.index ["wishlist_id", "variant_id"], name: "index_wishlist_items_on_wishlist_id_and_variant_id", unique: true
    t.index ["wishlist_id"], name: "index_wishlist_items_on_wishlist_id"
  end

  create_table "wishlists", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_wishlists_on_user_id", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "addresses", "users"
  add_foreign_key "cart_items", "carts"
  add_foreign_key "cart_items", "variants"
  add_foreign_key "carts", "users"
  add_foreign_key "option_value_variants", "option_values"
  add_foreign_key "option_value_variants", "variants"
  add_foreign_key "option_values", "option_types"
  add_foreign_key "order_events", "orders"
  add_foreign_key "order_events", "users"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "variants"
  add_foreign_key "orders", "addresses", column: "billing_address_id"
  add_foreign_key "orders", "addresses", column: "shipping_address_id"
  add_foreign_key "orders", "discounts"
  add_foreign_key "orders", "users"
  add_foreign_key "payments", "orders"
  add_foreign_key "product_option_types", "option_types"
  add_foreign_key "product_option_types", "products"
  add_foreign_key "product_relations", "products"
  add_foreign_key "product_relations", "products", column: "related_product_id"
  add_foreign_key "products", "categories"
  add_foreign_key "return_items", "order_items"
  add_foreign_key "return_items", "returns"
  add_foreign_key "returns", "orders"
  add_foreign_key "returns", "users"
  add_foreign_key "reviews", "products"
  add_foreign_key "reviews", "users"
  add_foreign_key "sessions", "users"
  add_foreign_key "shipments", "orders"
  add_foreign_key "shipments", "shipping_methods"
  add_foreign_key "stock_items", "stock_locations"
  add_foreign_key "stock_items", "variants"
  add_foreign_key "variants", "products"
  add_foreign_key "wishlist_items", "variants"
  add_foreign_key "wishlist_items", "wishlists"
  add_foreign_key "wishlists", "users"
end
