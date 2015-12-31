class PivotalTrackerStory < ActiveRecord::Base
  VALID_STATES = %w(unscheduled unstarted started finished delivered accepted rejected deleted)

  validates_presence_of :tracker_id, :name, :state
  validates_inclusion_of :state, in: VALID_STATES

  scope :without_pull_requests, -> { where(pull_request_nos: '{}') }
  scope :in_progress, -> { where(state: in_progress_states) }
  scope :for_user, lambda { |user| where("'#{user.pt_id}' = ANY(pt_owner_ids)") }

  def pt_owner_ids
    super.map(&:to_i)
  end

  def pull_request_nos
    super.map(&:to_i)
  end

  def self.in_progress_states
    %w(started rejected)
  end

  def self.only_update_states
    PivotalTrackerStory::VALID_STATES.reject {|state| %w(started rejected deleted).include?(state) }
  end
end
