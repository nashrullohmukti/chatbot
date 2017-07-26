class CreateIntentResponses < ActiveRecord::Migration[5.1]
  def change
    create_table :intent_responses do |t|
      t.string :speech
      t.references :intent

      t.timestamps
    end
  end
end
