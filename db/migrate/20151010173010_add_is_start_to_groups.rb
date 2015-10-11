class AddIsStartToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :is_start, :boolean
  end
end
