class AddEntityIdToEntity < ActiveRecord::Migration[5.1]
  def change
    add_column :entities, :entityId, :string
  end
end
