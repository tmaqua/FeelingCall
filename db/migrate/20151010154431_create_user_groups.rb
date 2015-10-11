class CreateUserGroups < ActiveRecord::Migration
  def change
    create_table :user_groups do |t|
      t.integer :user_id
      t.integer :group_id
      t.integer :like_user_id
      t.boolean :is_ready

      t.timestamps null: false
    end
  end
end
