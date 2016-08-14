require 'rails_helper'

describe LitaHookForwardService do
  before do
    ENV['LITA_HOOK_FORWARD_URL'] = 'https://fake-url.com'
  end

  describe '#send_message' do
    it 'makes a HTTP GET to the url' do
      service = LitaHookForwardService.new('msg', 'bob,#devs')

      mock(Excon).get(
        'https://fake-url.com',
        query: {
          targets: 'bob,#devs',
          message: 'msg'
        }
      )

      service.send_message
    end
  end

  describe '.url' do
    it 'returns url of the lita web hook forwarder' do
      expect(LitaHookForwardService.url).to eq('https://fake-url.com')
    end
  end
end
