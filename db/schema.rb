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

ActiveRecord::Schema.define(version: 20170726092140) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.boolean "auto"
    t.text "contexts"
    t.text "templates"
    t.integer "priority"
    t.string "intent_id"
    t.bigint "company_id"
    t.index ["company_id"], name: "index_categories_on_company_id"
    t.index ["slug"], name: "index_categories_on_slug", unique: true
  end

  create_table "chats", force: :cascade do |t|
    t.string "question"
    t.string "answer"
    t.string "state"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_chats_on_category_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.text "address"
    t.string "telephone"
    t.string "logo"
    t.string "domain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "entities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "company_id"
    t.string "entityId"
    t.index ["company_id"], name: "index_entities_on_company_id"
  end

  create_table "entries", force: :cascade do |t|
    t.string "name"
    t.bigint "entity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["entity_id"], name: "index_entries_on_entity_id"
  end

  create_table "intent_affected_contexts", force: :cascade do |t|
    t.string "name"
    t.integer "lifespan"
    t.bigint "intent_response_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["intent_response_id"], name: "index_intent_affected_contexts_on_intent_response_id"
  end

  create_table "intent_parameters", force: :cascade do |t|
    t.string "data_type"
    t.string "name"
    t.string "value"
    t.bigint "intent_response_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["intent_response_id"], name: "index_intent_parameters_on_intent_response_id"
  end

  create_table "intent_responses", force: :cascade do |t|
    t.string "speech"
    t.bigint "intent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["intent_id"], name: "index_intent_responses_on_intent_id"
  end

  create_table "intent_user_says", force: :cascade do |t|
    t.string "text"
    t.bigint "intent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["intent_id"], name: "index_intent_user_says_on_intent_id"
  end

  create_table "intents", force: :cascade do |t|
    t.string "name"
    t.string "intent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "entity_id"
    t.index ["entity_id"], name: "index_intents_on_entity_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.string "role"
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.integer "invited_by_id"
    t.string "invited_by_type"
    t.bigint "company_id"
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "chats", "categories"
  add_foreign_key "entities", "companies"
  add_foreign_key "entries", "entities"
  add_foreign_key "intent_affected_contexts", "intent_responses"
  add_foreign_key "intent_parameters", "intent_responses"
  add_foreign_key "intents", "entities"
end
