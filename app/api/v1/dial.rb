require 'twilio-ruby'

module V1
  class Dial < Grape::API
    helpers do
      
    end

    resource :twiml do
      format :xml

      desc "GET api/v1/twiml/dial_murakami 俺にダイアルする"
      get '/dial_murakami' do
        caller = "むらかみともき"
        unco = params[:unco]

        xml_str = Twilio::TwiML::Response.new do |response|
          response.Say "こんにちは #{caller}さん", language: "ja-jp"
          response.Say "#{unco}", language: "ja-jp"
          response.Dial "+818041317484", callerId: Settings.twilio.from_tel
        end

        xml_str
      end

      desc "GET api/v1/twiml/matching"
      get '/matching' do
        group_id = params[:group_id]
        user_id = params[:user_id]
        from_user = UserGroup.find_by(group_id: group_id, user_id: user_id)
        to_user = UserGroup.find_by(group_id: group_id, user_id: from_user.like_user_id)
        phone_number = User.find(from_user.like_user_id).phone_number.gsub(/^0/, "+81")

        xml_str = Twilio::TwiML::Response.new do |response|

            if to_user.like_user_id == from_user.user_id && to_user.user_id == from_user.like_user_id
              response.Say "マッチングしました", language: "ja-jp"
              response.Dial "#{phone_number}", callerId: Settings.twilio.from_tel
            else
              response.Say "ざんねんでした", language: "ja-jp"
            end
        end
        xml_str
      end

    end

    resource :twilio do
      format :txt

      desc 'GET /api/v1/twilio/token'
      get '/token' do
        account_sid = Settings.twilio.account_sid
        auth_token = Settings.twilio.auth_token
        app_sid = Settings.twilio.app_sid

        capability = Twilio::Util::Capability.new account_sid, auth_token
        capability.allow_client_outgoing app_sid
        token = capability.generate

        token
      end

    end
  end
end