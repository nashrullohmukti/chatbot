class CreateIntentParameters < ActiveRecord::Migration[5.1]
  def change
    create_table :intent_parameters do |t|
      t.string :data_type
      t.string :name
      t.string :value
      t.references :intent_response, foreign_key: true

      t.timestamps
    end
  end
end
