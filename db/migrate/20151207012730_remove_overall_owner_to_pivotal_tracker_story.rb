class RemoveOverallOwnerToPivotalTrackerStory < ActiveRecord::Migration
  def change
    remove_column :pivotal_tracker_stories, :overall_owner
  end
end
