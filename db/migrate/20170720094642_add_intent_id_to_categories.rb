class AddIntentIdToCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :intent_id, :string
  end
end
