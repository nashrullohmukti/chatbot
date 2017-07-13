class CreateChats < ActiveRecord::Migration[5.1]
  def change
    create_table :chats do |t|
      t.string :question
      t.string :answer
      t.string :state
      t.references :category, foreign_key: true

      t.timestamps
    end
  end
end
