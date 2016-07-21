class AddPersonalSlackWebhookToUser < ActiveRecord::Migration
  def change
    add_column :users, :personal_slack_webhook, :string
  end
end
