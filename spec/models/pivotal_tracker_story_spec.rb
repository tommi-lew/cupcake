require 'rails_helper'

describe PivotalTrackerStory do
  let(:story) { create(:pivotal_tracker_story) }

  it { should validate_presence_of :tracker_id }
  it { should validate_presence_of :name }
  it { should validate_inclusion_of(:state).in_array(PivotalTrackerStory::VALID_STATES) }

  describe 'scopes' do
    describe '.without_pull_requests' do
      it 'return stories without pull request' do
        stories_without_pr = create_list(:pivotal_tracker_story, 2)
        create(:pivotal_tracker_story, pull_request_nos: [1])

        stories = PivotalTrackerStory.without_pull_requests

        expect(stories).to include(*stories_without_pr)
      end
    end

    describe '.for_user' do
      it 'returns stories for a specific user' do
        user = create(:user)
        story = create(:pivotal_tracker_story, pt_owner_ids: [user.pt_id])
        create(:pivotal_tracker_story)

        stories = PivotalTrackerStory.for_user(user)

        expect(stories.size).to eq(1)
        expect(stories.first).to eq(story)
      end
    end
  end

  describe '#pt_owner_ids' do
    it 'converts array of string to integers' do
      expect(story.pt_owner_ids).to eq([2222222, 3333333])
    end
  end

  describe '#pull_request_nos' do
    it 'converts array of string to integers' do
      create(:pivotal_tracker_story, pull_request_nos: [2222222, 3333333])
      expect(PivotalTrackerStory.last.pull_request_nos).to eq([2222222, 3333333])
    end
  end

  describe '.create_and_update_states' do
    it 'return states' do
      expect(PivotalTrackerStory.create_and_update_states).to eq(%w(started))
    end
  end

  describe '.only_update_states' do
    it 'return states' do
      expected_states = %w(unscheduled unstarted finished delivered accepted rejected)
      expect(PivotalTrackerStory.only_update_states).to eq(expected_states)
    end
  end
end
