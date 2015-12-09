class AddEnabledAndRoleToUser < ActiveRecord::Migration
  def change
    add_column :users, :enabled, :boolean, default: false
    add_column :users, :role, :string, default: nil
  end
end
