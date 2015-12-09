require 'rails_helper'

describe PivotalTrackerService do
  let(:service) { PivotalTrackerService.new }

  def fake_response_body(custom_values = {})
    [{
       "kind" => "story",
       "id" => 111111111,
       "created_at" => "2015-08-01T12:00:00Z",
       "updated_at" => "2015-08-01T13:00:00Z",
       "estimate" => 1,
       "story_type" => "feature",
       "name" => "Fake story",
       "description" => "",
       "current_state" => "started",
       "requested_by_id" => 2222222,
       "project_id" => 123456,
       "url" => "https://www.pivotaltracker.com/story/show/111111111",
       "owner_ids" => [2222222, 3333333],
       "labels" => [],
       "owned_by_id" => 2222222
     }.merge(custom_values)]
  end

  describe '#get_stories' do
    it 'get stories' do
      fake_response = Object.new

      stub(fake_response).body { fake_response_body.to_json }
      mock(Excon).get(anything, anything) { fake_response }

      stories = service.get_stories

      expect(stories).to eq(fake_response_body)
    end
  end

  describe '#create_or_update_stories' do
    it 'create new pivotal tracker stories' do
      expect {
        service.create_or_update_stories(fake_response_body, update_only: false)
      }.to change(PivotalTrackerStory, :count).by(1)

      story = PivotalTrackerStory.last
      expect(story.tracker_id).to eq '111111111'
      expect(story.name).to eq 'Fake story'
      expect(story.pt_owner_ids).to eq [2222222, 3333333]
      expect(story.data).to eq fake_response_body.first
    end

    it 'updates existing pivotal tracker stories' do
      create(
        :pivotal_tracker_story,
        tracker_id: '111111111',
        name: 'Fake story',
        state: 'started',
        data: fake_response_body.first
      )

      changed_fake_response_body = fake_response_body.dup
      changed_fake_response_body[0]['name'] = 'Very fake story'

      expect {
        service.create_or_update_stories(changed_fake_response_body)
      }.to_not change { PivotalTrackerStory.count }

      story = PivotalTrackerStory.last
      expect(story.name).to eq 'Very fake story'
    end

    context 'update only' do
      before do
        create(
          :pivotal_tracker_story,
          tracker_id: '111111111',
          name: 'Fake story',
          state: 'started',
          data: fake_response_body
        )
      end

      it 'does not create a new story' do
        expect {
          service.create_or_update_stories(fake_response_body, update_only: true)
        }.to change(PivotalTrackerStory, :count).by(0)
      end

      it 'update existing story' do
        service.create_or_update_stories(
          fake_response_body('owner_ids' => [9999999]),
          update_only: true
        )

        story = PivotalTrackerStory.last
        expect(story.pt_owner_ids).to eq([9999999])
      end
    end
  end

  describe '#stories_endpoint' do
    it 'returns endpoint url' do
      expected_url = "/projects/#{Rails.application.secrets.pivotal_tracker_project_id}/stories"
      expect(service.send(:stories_endpoint)).to eq(expected_url)
    end

    context 'with filters' do
      it 'returns endpoint url' do
        expected_url = "/projects/#{Rails.application.secrets.pivotal_tracker_project_id}/stories?filter=state:started"
        expect(service.send(:stories_endpoint, 'state:started')).to eq(expected_url)
      end
    end
  end

  describe '#story_endpoint' do
    it 'returns endpoint url' do
      expected_url = "/projects/#{Rails.application.secrets.pivotal_tracker_project_id}/stories/12345"
      expect(service.send(:story_endpoint, 12345)).to eq(expected_url)
    end
  end

  describe '#headers' do
    it 'returns http headers' do
      expected_headers = {
        'X-TrackerToken' => Rails.application.secrets.pivotal_tracker_token,
        'Content-Type' => 'application/json'
      }

      expect(service.send(:headers)).to eq(expected_headers)
    end
  end
end
