class CreateIntentUserSays < ActiveRecord::Migration[5.1]
  def change
    create_table :intent_user_says do |t|
      t.string :text
      t.string :alias
      t.string :meta
      t.references :category

      t.timestamps
    end
  end
end
