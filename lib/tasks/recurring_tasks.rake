task :recurring_tasks => :environment do
  PivotalTrackerService.new.bulk_update
  Rails.logger.info 'Updated stories'

  if [1, 3, 5].include?(Date.today.wday)
    StoriesSummarizer.send_individual_summaries
    StoriesSummarizer.send_overall_summaries
    Rails.logger.info 'Sent summaries'
  end

  # Accepted stories reminders
  if [1, 2, 3, 4, 5].include?(Date.today.wday)
    users = User.enabled.where.not(personal_slack_webhook: nil)
    users.each do |user|
      reminderer = DeliveredStoriesReminderer.new(user)
      reminderer.perform
    end
    Rails.logger.info 'Sent accepted stories reminders'
  end
end
