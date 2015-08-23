class AddOverallOwnerToPivotalTrackerStory < ActiveRecord::Migration
  def change
    add_column :pivotal_tracker_stories, :overall_owner, :string
  end
end
