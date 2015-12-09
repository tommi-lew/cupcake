class PivotalTrackerService
  ENDPOINT_HOST = 'https://www.pivotaltracker.com/services/v5'

  def initialize
    @project_id = Rails.application.secrets.pivotal_tracker_project_id
    @pivotal_tracker_token = Rails.application.secrets.pivotal_tracker_token
  end

  def get_stories(filters = nil)
    url = ENDPOINT_HOST + stories_endpoint(filters)
    response = Excon.get(url, headers: headers)
    JSON.parse(response.body)
  end

  def create_or_update_stories(raw_stories, update_only: true)
    raw_stories.each do |raw_story|
      story = if !update_only
                PivotalTrackerStory.find_or_create_by(tracker_id: raw_story['id'])
              else
                PivotalTrackerStory.find_by(tracker_id: raw_story['id'])
              end

      next unless story

      story.update_attributes(
        name: raw_story['name'],
        pt_owner_ids: raw_story['owner_ids'],
        state: raw_story['current_state'],
        data: raw_story
      )
    end
  end

  def bulk_update
    PivotalTrackerStory.create_and_update_states.each do |state|
      json_response = get_stories("state:#{state}")
      create_or_update_stories(json_response, update_only: false)
    end

    PivotalTrackerStory.only_update_states.each do |state|
      json_response = get_stories("state:#{state}")
      create_or_update_stories(json_response, update_only: true)
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
