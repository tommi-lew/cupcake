task :recurring_tasks => :environment do
  PivotalTrackerService.new.bulk_update
  Rails.logger.info 'Updated stories'

  if [1, 3, 5].include?(Date.today.wday)
    StoriesSummarizer.send_individual_summaries
    StoriesSummarizer.send_overall_summaries
    Rails.logger.info 'Sent summaries'
  end
end
