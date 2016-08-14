class DeliveredStoriesReminderer
  def initialize(user)
    @user = user
    @stories = []
  end

  def perform
    gather_stories
    return if @stories.count == 0
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
    msg = "Hello from Cupcake!\n There #{'is'.pluralize(stories_count)} #{stories_count} #{'story'.pluralize(stories_count)} waiting for you to accept leh."

    lita_hook_forward_service = LitaHookForwardService.new(msg, @user.slack_username)
    lita_hook_forward_service.send_message
  end
end
