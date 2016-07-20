class PivotalTrackerService
  ENDPOINT_HOST = 'https://www.pivotaltracker.com/services/v5'

  def initialize
    @project_id = Rails.application.secrets.pivotal_tracker_project_id
    @pivotal_tracker_token = Rails.application.secrets.pivotal_tracker_token
  end

  def get_stories(filters = nil, state = nil)
    url = ENDPOINT_HOST + stories_endpoint(filters: filters, state: state)
    response = Excon.get(url, headers: headers)
    JSON.parse(response.body)
  end

  def get_story(story_id)
    url = ENDPOINT_HOST + story_endpoint(story_id)
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

      update_story(story, raw_story)
    end
  end

  def update_from_local_stories
    PivotalTrackerStory.where(state: 'started').each do |story|
      raw_story = get_story(story.id)
      update_story(story, raw_story)
    end
  end

  def bulk_update
    update_from_local_stories

    PivotalTrackerStory.in_progress_states.each do |state|
      json_response = get_stories("state:#{state}")
      create_or_update_stories(json_response, update_only: false)
    end

    PivotalTrackerStory.only_update_states.each do |state|
      json_response = get_stories("state:#{state}")
      create_or_update_stories(json_response, update_only: true)
    end
  end

  private

  def update_story(story, raw_story)
    if raw_story['kind'] == 'error' && raw_story['code'] == 'unfound_resource'
      story.update_attributes(state: 'deleted')

    else
      story.update_attributes(
        name: raw_story['name'],
        pt_owner_ids: raw_story['owner_ids'],
        state: raw_story['current_state'],
        data: raw_story
      )
    end
  end

  def stories_endpoint(filters: nil, state: nil)
    url = "/projects/#{@project_id}/stories"
    url_params = []

    if state.present?
      url_params << "with_state=#{state}"
    end

    if filters.present?
      url_params << "filter=#{filters}"
    end

    if url_params.present?
      url = url + "?" + url_params.join("&")
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
