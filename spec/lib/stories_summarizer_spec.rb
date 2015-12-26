require 'rails_helper'

describe StoriesSummarizer do
  describe '.send_individual_summaries' do
    it 'sends each developer their started stories' do
      dev = create(:user, roles: ['dev'])
      story = create(:pivotal_tracker_story, pt_owner_ids: [dev.pt_id])

      mock(PivotalTrackerStoryMailer).individual_summary(dev, [story]).mock!.deliver_now!

      StoriesSummarizer.send_individual_summaries
    end
  end

  describe '.send_overall_summaries' do
    it "sends each product manager a summary of each developer's open stories" do
      product_manager = create(:user, roles: ['product'])
      dev1 = create(:user, roles: ['dev'])
      dev2 = create(:user, roles: ['dev'])

      story1 = create(:pivotal_tracker_story, pt_owner_ids: [dev1.pt_id])
      story2 = create(:pivotal_tracker_story, pt_owner_ids: [dev2.pt_id])

      mock(PivotalTrackerStoryMailer).overall_summary(
        product_manager,
        [{ dev1.name => [story1] }, { dev2.name => [story2] }],
      ).mock!.deliver_now!

      StoriesSummarizer.send_overall_summaries
    end
  end
end
