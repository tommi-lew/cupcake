class PivotalTrackerStory < ActiveRecord::Base
  VALID_STATES = %w(unscheduled unstarted started finished delivered accepted rejected deleted)

  validates_presence_of :tracker_id, :name, :state
  validates_inclusion_of :state, in: VALID_STATES

  scope :without_pull_requests, -> { where(pull_request_nos: '{}') }
  scope :for_user, lambda { |user| where("'#{user.pt_id}' = ANY(pt_owner_ids)") }

  def pt_owner_ids
    super.map(&:to_i)
  end

  def pull_request_nos
    super.map(&:to_i)
  end

  def self.create_and_update_states
    %w(started)
  end

  def self.only_update_states
    PivotalTrackerStory::VALID_STATES.reject {|state| %w(started deleted).include?(state) }
  end
end
