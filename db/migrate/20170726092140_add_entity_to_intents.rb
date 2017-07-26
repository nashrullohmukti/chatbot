class AddEntityToIntents < ActiveRecord::Migration[5.1]
  def change
    add_reference :intents, :entity, foreign_key: true
  end
end
