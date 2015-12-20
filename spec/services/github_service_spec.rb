require 'rails_helper'

describe GithubService do
  let(:service) { GithubService.new }

  describe '#update_pivotal_tracker_stories' do
    it 'update pivotal tracker stories with pull request id' do
      story1 = create(:pivotal_tracker_story)
      story2 = create(:pivotal_tracker_story)

      fake_pr1 = Object.new
      stub(fake_pr1).title { "[##{story1.tracker_id}] #{story1.name}" }
      stub(fake_pr1).number { 10 }

      fake_pr2 = Object.new
      stub(fake_pr2).title { "[##{story2.tracker_id}] #{story2.name}" }
      stub(fake_pr2).number { 20 }

      fake_pr3 = Object.new
      stub(fake_pr3).title { "[#9] No existent story" }
      stub(fake_pr3).number { 90 }

      stub(service).get_pull_requests { [fake_pr1, fake_pr2, fake_pr3] }

      service.update_pivotal_tracker_stories

      story1.reload
      story2.reload

      expect(story1.pull_request_nos).to eq([10])
      expect(story2.pull_request_nos).to eq([20])
    end
  end

  describe '#get_pull_requests' do
    it 'hits github api and return open pull requests' do
      mock.instance_of(Github::Client).pull_requests.mock!.list { 'pull_requests' }

      pull_requests = service.get_pull_requests

      expect(pull_requests).to eq 'pull_requests'
    end
  end
end
