require 'rails_helper'

describe AcceptedStoriesReminderer do
  let(:user) { create(:user, :with_personal_slack_webhook) }
  let(:reminderer) { AcceptedStoriesReminderer.new(user) }

  describe '#perform' do
    it 'sends out a reminder for delivered stories' do
      mock(reminderer).gather_stories
      mock(reminderer).send_reminder

      reminderer.perform
    end
  end

  describe '#gather_stories' do
    let(:params) { { filters: "owner:#{user.name} state:delivered" } }

    it 'gets delivered stories from pivotal tracker service' do
      mock.instance_of(PivotalTrackerService).get_stories(params) {
        fake_stories_response_body('owner_ids' => [user.pt_id])
      }

      reminderer.gather_stories
    end

    it 'stores stories in @stories instance variable' do
      stub.instance_of(PivotalTrackerService).get_stories(params) {
        fake_stories_response_body('owner_ids' => [user.pt_id])
      }

      reminderer.gather_stories

      stories = reminderer.instance_variable_get(:@stories)

      expect(stories).to be_a(Array)

      story = stories.first
      expect(story.tracker_id).to eq('111111111')
      expect(story.name).to eq('Fake story')
      expect(story.state).to eq('started')
      expect(story.pt_owner_ids).to eq([user.pt_id])
    end
  end

  describe '#send_reminder' do
    it 'sends reminder with slack service' do
      fake_slack_service = Object.new
      msg = "Hello! There are 2 stories waiting for you to accept leh."

      mock(SlackService).new(msg, user.personal_slack_webhook) { fake_slack_service }
      mock(fake_slack_service).post

      stories = build_list(:pivotal_tracker_story, 2)
      reminderer.instance_variable_set(:@stories, stories)

      reminderer.send_reminder
    end
  end
end
