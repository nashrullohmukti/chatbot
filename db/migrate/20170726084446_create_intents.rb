class CreateIntents < ActiveRecord::Migration[5.1]
  def change
    create_table :intents do |t|
      t.string :name
      t.string :intent_id

      t.timestamps
    end
  end
end
