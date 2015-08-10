class AddPullRequestNoToPivotalTrackerStory < ActiveRecord::Migration
  def change
    add_column :pivotal_tracker_stories, :pull_request_no, :integer
  end
end
