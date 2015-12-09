task :recurring_tasks => :environment do
  StoriesSummarizer.send_individual_summaries
  StoriesSummarizer.send_overall_summaries

  Rails.logger.info 'Sent summaries'
end
