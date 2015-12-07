require 'rails_helper'

describe PivotalTrackerService do
  def fake_response_body
    [{
       "kind" => "story",
       "id" => 111111111,
       "created_at" => "2015-08-01T12:00:00Z",
       "updated_at" => "2015-08-01T13:00:00Z",
       "estimate" => 1,
       "story_type" =>"feature",
       "name" => "Fake story",
       "description" => "",
       "current_state" => "started",
       "requested_by_id" => 2222222,
       "project_id" => 123456,
       "url" => "https://www.pivotaltracker.com/story/show/111111111",
       "owner_ids" => [2222222, 3333333],
       "labels" => [],
       "owned_by_id" => 2222222
     }]
  end

  describe '.get_stories' do
    it 'get stories' do
      fake_response = Object.new

      stub(fake_response).body { fake_response_body.to_json }
      mock(Excon).get(anything, anything) { fake_response }

      stories = PivotalTrackerService.get_stories

      expect(stories).to eq(fake_response_body)
    end
  end

  describe '.create_or_update_stories' do
    it 'create new pivotal tracker stories' do
      expect {
        PivotalTrackerService.create_or_update_stories(fake_response_body)
      }.to change(PivotalTrackerStory, :count).by(1)

      story = PivotalTrackerStory.last
      expect(story.tracker_id).to eq '111111111'
      expect(story.name).to eq 'Fake story'
      expect(story.pt_owner_ids).to eq [2222222, 3333333]
      expect(story.data).to eq fake_response_body.first
    end

    it 'update existing pivotal tracker stories' do
      PivotalTrackerStory.create(
        tracker_id: '111111111',
        name: 'Fake story',
        state: 'started',
        data: fake_response_body.first
      )

      changed_fake_response_body = fake_response_body.dup
      changed_fake_response_body[0]['name'] = 'Very fake story'

      expect {
        PivotalTrackerService.create_or_update_stories(changed_fake_response_body)
      }.to_not change { PivotalTrackerStory.count }

      story = PivotalTrackerStory.last
      expect(story.name).to eq 'Very fake story'
    end
  end
end
