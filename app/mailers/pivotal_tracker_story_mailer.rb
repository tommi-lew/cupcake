class PivotalTrackerStoryMailer < ActionMailer::Base
  def individual_summary(user, stories)
    @user = user
    @stories = stories

    mail(
      to: user.email,
      from: Rails.application.secrets.action_mailer_from,
      subject: '[Cupcake] Your PT summary'
    )
  end

  def overall_summary(user, dev_stories)
    @user = user
    @dev_stories = dev_stories

    mail(
      to: user.email,
      from: Rails.application.secrets.action_mailer_from,
      subject: '[Cupcake] Your PT overall summary'
    )
  end
end
