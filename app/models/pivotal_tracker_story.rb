class PivotalTrackerStory < ActiveRecord::Base
  validates_presence_of :tracker_id, :name
end
