class AddCreatorIdToTasks < ActiveRecord::Migration[7.0]
  def change
    add_column :tasks, :creator_id, :integer
    add_index :tasks, :creator_id
  end
end
