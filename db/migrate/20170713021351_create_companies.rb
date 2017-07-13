class CreateCompanies < ActiveRecord::Migration[5.1]
  def change
    create_table :companies do |t|
      t.string :name
      t.text :address
      t.string :telephone
      t.string :logo
      t.string :domain

      t.timestamps
    end
  end
end
