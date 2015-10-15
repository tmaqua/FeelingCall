class CallController < ApplicationController
  def index
    # Find these values at twilio.com/user/account
    account_sid = Settings.twilio.account_sid
    auth_token = Settings.twilio.auth_token
    # This application sid will play a Welcome Message.
    demo_app_sid = 'AP8571cacbce913cab9a75697750b19ffc'
    capability = Twilio::Util::Capability.new account_sid, auth_token
    capability.allow_client_outgoing demo_app_sid
    @token = capability.generate
  end
end
