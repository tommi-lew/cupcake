class PivotalTrackerStory < ActiveRecord::Base
  validates_presence_of :tracker_id, :name

  scope :without_pull_requests, -> { where(pull_request_nos: '{}') }

  def pt_owner_ids
    super.map(&:to_i)
  end

  def pull_request_nos
    super.map(&:to_i)
  end
end
