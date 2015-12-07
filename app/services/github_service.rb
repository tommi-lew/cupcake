class GithubService
  def self.update_pivotal_tracker_stories
    pull_requests = self.get_pull_requests

    PivotalTrackerStory.without_pull_requests.each do |story|
      pull_request = pull_requests.find do |pr|
        !!pr.title.index(story.tracker_id)
      end

      next if pull_request.nil?

      story.update_attributes(pull_request_nos: [pull_request.number])
    end
  end

  def self.get_pull_requests
    self.github_client.pull_requests.list
  end

  private

  def self.github_client
    Github.new(user: ENV['GITHUB_OWNER'], repo: ENV['GITHUB_REPO'])
  end
end
