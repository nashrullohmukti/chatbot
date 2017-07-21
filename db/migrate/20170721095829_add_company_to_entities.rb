class AddCompanyToEntities < ActiveRecord::Migration[5.1]
  def change
    add_reference :entities, :company, foreign_key: true
  end
end
