class CreateIntentAffectedContexts < ActiveRecord::Migration[5.1]
  def change
    create_table :intent_affected_contexts do |t|
      t.string :name
      t.integer :lifespan
      t.references :intent_response, foreign_key: true

      t.timestamps
    end
  end
end
