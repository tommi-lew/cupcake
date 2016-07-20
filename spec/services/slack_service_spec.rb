require 'rails_helper'

describe SlackService do
  describe '#post' do
    it 'makes a HTTP POST to the webhook' do
      slack_service = SlackService.new('msg', 'webhook_url')

      mock(Excon).post('webhook_url', body: { text: 'msg' }.to_json)

      slack_service.post
    end
  end
end
