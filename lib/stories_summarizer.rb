class StoriesSummarizer
  def self.send_individual_summaries
    User.where(role: 'dev', enabled: true).each do |dev|
      stories = PivotalTrackerStory.for_user(dev)
      PivotalTrackerStoryMailer.individual_summary(dev, stories).deliver_now!
    end
  end

  def self.send_overall_summaries
    devs_and_stories = []

    User.where(role: 'dev', enabled: true).each do |dev|
      stories = PivotalTrackerStory.for_user(dev)
      devs_and_stories << { dev.name => stories.to_a }
    end

    User.where(role: 'product', enabled: true).each do |product_manager|
      PivotalTrackerStoryMailer.overall_summary(
        product_manager,
        devs_and_stories
      ).deliver_now!
    end
  end
end
