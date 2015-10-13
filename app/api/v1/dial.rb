require 'twilio-ruby'

module V1
  class Dial < Grape::API
    helpers do
      
    end

    resource :twiml do
      format :xml

      desc "GET api/v1/twiml/dial_murakami 俺にダイアルする"
      get '/dial_murakami' do
        caller = params[:From]
        puts "caller phone: #{caller.gsub(/\+81/, "0")}"

        xml_str = Twilio::TwiML::Response.new do |response|
          response.Say "こんにちは #{caller}さん", language: "ja-jp"
          response.Dial "+818041317484"
        end

        xml_str
      end

      desc "GET api/v1/twiml/hello say hello"
      get '/hello' do
        custom_params = params[:Custom]
        puts "custom params: #{custom_params}"
        
        xml_str = Twilio::TwiML::Response.new do |response|
          response.Say "こんにちは", language: "ja-jp"
        end

        xml_str
      end

    end

    resource :twilio do
      desc "GET api/v1/twilio/dial_murakami 俺にダイアルする"
      get '/dial_murakami' do
        # put your own credentials here
        account_sid = Settings.twilio.account_sid
        auth_token = Settings.twilio.auth_token

        # set up a client to talk to the Twilio REST API
        @client = Twilio::REST::Client.new account_sid, auth_token

        # alternatively, you can preconfigure the client like so
        Twilio.configure do |config|
          config.account_sid = account_sid
          config.auth_token = auth_token
        end

        # and then you can create a new client without parameters
        @client = Twilio::REST::Client.new

        @client.account.calls.create(
          from: Settings.twilio.from_tel, # twilio電話番号
          to:   '+818041317484', # 宛先の電話番号
          url: 'https://feeling-call.herokuapp.com/api/v1/twiml/hello',
          method: 'GET'
        )
      end
    end
  end
end