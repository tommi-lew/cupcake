require 'rails_helper'

describe PivotalTrackerStory do
  it { should validate_presence_of :tracker_id }
  it { should validate_presence_of :name }

  describe 'scopes' do
    describe '.without_pull_requests' do
      it 'return stories without pull request' do
        stories_without_pr = create_list(:pivotal_tracker_story, 2)
        create(:pivotal_tracker_story, pull_request_no: 1)

        stories = PivotalTrackerStory.without_pull_requests

        expect(stories).to include(*stories_without_pr)
      end
    end
  end
end
