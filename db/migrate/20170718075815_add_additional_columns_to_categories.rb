class AddAdditionalColumnsToCategories < ActiveRecord::Migration[5.1]
  def change
    add_column :categories, :auto, :boolean
    add_column :categories, :contexts, :text
    add_column :categories, :templates, :text
    add_column :categories, :priority, :integer
  end
end
