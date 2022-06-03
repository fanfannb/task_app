class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :content
      t.datetime :deadline
      t.integer :user_id
      t.integer :status, default: 1

      t.timestamps
    end
    add_index :tasks, :user_id
  end
end
