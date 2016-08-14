class LitaHookForwardService
  attr_accessor :msg, :targets

  def initialize(msg, targets)
    @msg = msg
    @targets = targets
  end

  def send_message
    Excon.get(
      self.class.url,
      query: {
        targets: targets,
        message: msg
      }
    )
  end

  def self.url
    ENV['LITA_HOOK_FORWARD_URL']
  end
end
