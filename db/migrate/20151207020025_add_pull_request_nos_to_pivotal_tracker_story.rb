class AddPullRequestNosToPivotalTrackerStory < ActiveRecord::Migration
  def change
    add_column :pivotal_tracker_stories, :pull_request_nos, :text, array: true, default: []
  end
end
