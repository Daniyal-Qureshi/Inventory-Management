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

ActiveRecord::Schema[7.0].define(version: 2020_09_16_154424) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "inventory_statuses", ["on_shelf", "shipped"]

  create_table "addresses", force: :cascade do |t|
    t.string "recipient", null: false
    t.string "street_1", null: false
    t.string "street_2"
    t.string "city", null: false
    t.string "state", null: false
    t.string "zip", null: false
  end

  create_table "employees", force: :cascade do |t|
    t.string "name", null: false
    t.string "access_code", limit: 5, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["access_code"], name: "index_employees_on_access_code", unique: true
  end

  create_table "inventories", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.enum "status", null: false, enum_type: "inventory_statuses"
    t.bigint "order_id"
    t.index ["order_id"], name: "index_inventories_on_order_id"
    t.index ["product_id"], name: "index_inventories_on_product_id"
    t.index ["status"], name: "index_inventories_on_status"
  end

  create_table "inventory_status_changes", force: :cascade do |t|
    t.bigint "inventory_id", null: false
    t.enum "status_from", enum_type: "inventory_statuses"
    t.enum "status_to", null: false, enum_type: "inventory_statuses"
    t.bigint "actor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actor_id"], name: "index_inventory_status_changes_on_actor_id"
    t.index ["inventory_id"], name: "index_inventory_status_changes_on_inventory_id"
  end

  create_table "order_line_items", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "product_id", null: false
    t.integer "quantity", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id", "product_id"], name: "index_order_line_items_on_order_id_and_product_id", unique: true
    t.index ["order_id"], name: "index_order_line_items_on_order_id"
    t.index ["product_id"], name: "index_order_line_items_on_product_id"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "ships_to_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ships_to_id"], name: "index_orders_on_ships_to_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "USD", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_products_on_name", unique: true
  end

  add_foreign_key "inventories", "orders"
  add_foreign_key "inventories", "products"
  add_foreign_key "inventory_status_changes", "employees", column: "actor_id"
  add_foreign_key "inventory_status_changes", "inventories"
  add_foreign_key "orders", "addresses", column: "ships_to_id"

  create_view "product_on_shelf_quantities", sql_definition: <<-SQL
      SELECT p.id AS product_id,
      count(i.product_id) AS quantity
     FROM (products p
       LEFT JOIN inventories i ON (((p.id = i.product_id) AND (i.status = 'on_shelf'::inventory_statuses))))
    GROUP BY p.id
    ORDER BY p.id;
  SQL
end
