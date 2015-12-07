class AddPtOwnerIdsToPivotalTrackerStory < ActiveRecord::Migration
  def change
    add_column :pivotal_tracker_stories, :pt_owner_ids, :text, array: true, default: []
  end
end
