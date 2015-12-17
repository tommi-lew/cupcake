class AddRolesToUser < ActiveRecord::Migration
  def change
    add_column :users, :roles, :text, array: true, default: []
  end
end
