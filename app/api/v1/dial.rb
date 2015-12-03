require 'twilio-ruby'

module V1
  class Dial < Grape::API

    resource :twiml do
      format :xml

      desc "GET api/v1/twiml/matching"
      get '/matching' do
        group_id = params[:group_id]
        user_id = params[:user_id]

        begin
          from_user = UserGroup.find_by(group_id: group_id, user_id: user_id)
          to_user = UserGroup.find_by(group_id: group_id, user_id: from_user.like_user_id)
          phone_number = User.find(from_user.like_user_id).phone_number.gsub(/^0/, "+81")
          read_text = "こちらは、フィーリング運営事務局です。お相手は、あなたに興味が無いようです。またのご利用をお待ちしております。"

          xml_str = Twilio::TwiML::Response.new do |response|

            if to_user.like_user_id == from_user.user_id && to_user.user_id == from_user.like_user_id
              # response.Say "マッチングしました", language: "ja-jp"
              # response.Dial "#{phone_number}", callerId: Settings.twilio.from_tel
              response.Dial :callerId => Settings.twilio.from_tel do |dial|
                dial.Client "FeelingCall"
              end
            else
              response.Say read_text, language: "ja-jp"
            end
          end
          xml_str # => response Twiml 

        rescue Exception => e
          # rescueして失敗twimlを返す
          print("****ERROR****\n#{e}\n")
          xml_str = Twilio::TwiML::Response.new do |response|
            response.Say "電話に失敗しました", language: "ja-jp"
            response.Say "データがふせいです", language: "ja-jp"
          end
          xml_str
        end
      end

    end

    resource :twilio do
      format :txt

      desc 'GET /api/v1/twilio/outgoing'
      get '/outgoing' do
        account_sid = Settings.twilio.account_sid
        auth_token = Settings.twilio.auth_token
        app_sid = Settings.twilio.app_sid

        capability = Twilio::Util::Capability.new account_sid, auth_token
        capability.allow_client_outgoing app_sid
        token = capability.generate

        token
      end

      desc 'GET /api/v1/twilio/incoming'
      get '/incoming' do
        account_sid = Settings.twilio.account_sid
        auth_token = Settings.twilio.auth_token
        client_name = "FeelingCall"
 
        capability = Twilio::Util::Capability.new account_sid, auth_token
        capability.allow_client_incoming client_name
        token = capability.generate
      end

    end
  end
end