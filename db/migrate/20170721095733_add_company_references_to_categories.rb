class AddCompanyReferencesToCategories < ActiveRecord::Migration[5.1]
  def change
    add_reference :categories, :company
  end
end
