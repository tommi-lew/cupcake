class StoriesSummarizer
  def self.send_individual_summaries
    User.enabled.developer.each do |dev|
      stories = PivotalTrackerStory.for_user(dev).in_progress
      SummarizedStoriesMailer.individual_summary(dev, stories).deliver_now!
    end
  end

  def self.send_overall_summaries
    devs_and_stories = []

    User.developer.each do |dev|
      stories = PivotalTrackerStory.for_user(dev).in_progress
      devs_and_stories << { dev.name => stories.to_a }
    end

    User.enabled.product.each do |product_manager|
      SummarizedStoriesMailer.overall_summary(
        product_manager,
        devs_and_stories
      ).deliver_now!
    end
  end
end
