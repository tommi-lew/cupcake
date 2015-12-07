class RemovePullRequestNoInPivotalTrackerStory < ActiveRecord::Migration
  def change
    remove_column :pivotal_tracker_stories, :pull_request_no
  end
end
