class SlackService
  def initialize(msg, webhook_url)
    @msg = msg
    @webhook_url = webhook_url
  end

  def send_message
    Excon.post(
      @webhook_url,
      body: { text: @msg }.to_json
    )
  end
end
