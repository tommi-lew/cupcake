require 'rails_helper'

describe PivotalTrackerStoryMailer do
  describe '.individual_summary' do
    before do
      @dev = create(:user)
      @story = create(:pivotal_tracker_story, pt_owner_ids: [@dev.pt_id])

      @mail = PivotalTrackerStoryMailer.individual_summary(@dev, [@story])
    end

    it 'delivers with correct recipient, sender and subject' do
      expect(@mail.subject).to eq('[Cupcake] Your PT summary')
      expect(@mail.to).to eq([@dev.email])
      expect(@mail.from).to eql([Rails.application.secrets.action_mailer_from])
    end

    it 'renders with correct information' do
      expect(@mail.body.encoded).to match(@dev.name)
      expect(@mail.body.encoded).to match(@story.tracker_id)
      expect(@mail.body.encoded).to match(@story.name)
    end
  end

  describe '.overall_summary' do
    before do
      @product_manager = create(:user)
      @dev = create(:user)
      @story = create(:pivotal_tracker_story, pt_owner_ids: [@dev.pt_id])

      @mail = PivotalTrackerStoryMailer.overall_summary(@product_manager, [{ @dev.name => [@story] }])
    end

    it 'delivers with correct recipient, sender and subject' do
      expect(@mail.subject).to eq('[Cupcake] Your PT overall summary')
      expect(@mail.to).to eq([@product_manager.email])
      expect(@mail.from).to eql([Rails.application.secrets.action_mailer_from])
    end

    it 'renders with correct information' do
      expected_line1 = "Hi #{@product_manager.name}. Here is the overall summary as of #{Date.current}."
      expected_line2 = "#{@dev.name}: 1 open stories"

      expect(@mail.body.encoded).to match(expected_line1)
      expect(@mail.body.encoded).to match(expected_line2)
      expect(@mail.body.encoded).to match(@story.tracker_id)
      expect(@mail.body.encoded).to match(@story.name)
    end
  end
end
