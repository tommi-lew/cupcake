class StoriesSummarizer
  def self.send_individual_summaries
    User.developer.where(enabled: true).each do |dev|
      stories = PivotalTrackerStory.for_user(dev).where(state: 'started')
      PivotalTrackerStoryMailer.individual_summary(dev, stories).deliver_now!
    end
  end

  def self.send_overall_summaries
    devs_and_stories = []

    User.developer.each do |dev|
      stories = PivotalTrackerStory.for_user(dev).where(state: 'started')
      devs_and_stories << { dev.name => stories.to_a }
    end

    User.product.(enabled: true).each do |product_manager|
      PivotalTrackerStoryMailer.overall_summary(
        product_manager,
        devs_and_stories
      ).deliver_now!
    end
  end
end
