class PivotalTrackerService
  ENDPOINT_HOST = 'https://www.pivotaltracker.com/services/v5'

  def initialize
    @project_id = Rails.application.secrets.pivotal_tracker_project_id
    @pivotal_tracker_token = Rails.application.secrets.pivotal_tracker_token
  end

  def get_started_stories
    url = ENDPOINT_HOST + stories_endpoint('state:started')
    response = Excon.get(url, headers: headers)
    JSON.parse(response.body)
  end

  def create_or_update_stories(raw_stories)
    raw_stories.each do |raw_story|
      story = PivotalTrackerStory.find_or_create_by(tracker_id: raw_story['id'])

      story.update_attributes(
        name: raw_story['name'],
        pt_owner_ids: raw_story['owner_ids'],
        state: raw_story['current_state'],
        data: raw_story
      )
    end
  end

  private

  def stories_endpoint(filters = nil)
    url = "/projects/#{@project_id}/stories"

    if filters.present?
      return url + "?filter=#{filters}"
    end

    url
  end

  def story_endpoint(story_id)
    "/projects/#{@project_id}/stories/#{story_id}"
  end

  def headers
    {
      'X-TrackerToken' => @pivotal_tracker_token,
      'Content-Type' => 'application/json'
    }
  end
end
