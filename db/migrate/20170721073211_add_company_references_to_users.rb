class AddCompanyReferencesToUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :company
  end
end
