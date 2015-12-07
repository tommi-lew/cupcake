class PivotalTrackerService
  ENDPOINT_HOST = 'https://www.pivotaltracker.com/services/v5'

  def self.get_stories
    url = ENDPOINT_HOST + stories_endpoint + '?filter=state:started'
    response = Excon.get(url, headers: headers)
    JSON.parse(response.body)
  end

  def self.create_or_update_stories(raw_stories)
    raw_stories.each do |raw_story|
      story = PivotalTrackerStory.find_or_create_by(tracker_id: raw_story['id'])

      story.update_attributes(
        name: raw_story['name'],
        pt_owner_ids: raw_story['owner_ids'],
        data: raw_story
      )
    end
  end

  private

  def self.stories_endpoint
    "/projects/#{ENV['PIVOTAL_TRACKER_PROJECT_ID']}/stories"
  end

  def self.headers
    {
      'X-TrackerToken' => ENV['PIVOTAL_TRACKER_API_TOKEN'],
      'Content-Type' => 'application/json'
    }
  end
end
