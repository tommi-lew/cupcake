class AddStateToPivotalTrackerStory < ActiveRecord::Migration
  def change
    add_column :pivotal_tracker_stories, :state, :string
  end
end
