class CreateIntentResponses < ActiveRecord::Migration[5.1]
  def change
    create_table :intent_responses do |t|
      t.boolean :reset_contexts
      t.string :action
      t.string :speech
      t.references :category

      t.timestamps
    end
  end
end
