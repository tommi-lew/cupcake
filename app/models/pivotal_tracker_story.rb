class PivotalTrackerStory < ActiveRecord::Base
  VALID_STATES = %w(unscheduled unstarted started finished delivered accepted rejected)

  validates_presence_of :tracker_id, :name, :state
  validates_inclusion_of :state, in: VALID_STATES

  scope :without_pull_requests, -> { where(pull_request_nos: '{}') }

  def pt_owner_ids
    super.map(&:to_i)
  end

  def pull_request_nos
    super.map(&:to_i)
  end
end
