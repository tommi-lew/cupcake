class AcceptedStoriesReminderer
  def initialize(user)
    @user = user
    @stories = nil
  end

  def perform
    gather_stories
    send_reminder
  end

  def gather_stories
    json_data = PivotalTrackerService.new.get_stories(
      filters: "requester:#{@user.name} state:delivered"
    )

    @stories = PivotalTrackerService.parse_stories(json_data)
  end

  def send_reminder
    stories_count = @stories.count
    msg = "Hello! There #{'is'.pluralize(stories_count)} #{stories_count} #{'story'.pluralize(stories_count)} waiting for you to accept leh."

    slack_service = SlackService.new(msg, @user.personal_slack_webhook)
    slack_service.post
  end
end
