module V1
  class Root < Grape::API
    version 'v1'

    # 例外ハンドル 404
    rescue_from ActiveRecord::RecordNotFound do |e|
      rack_response({ message: e.message, status: 404 }.to_json, 404)
    end

    # 例外ハンドル 400
    rescue_from Grape::Exceptions::ValidationErrors do |e|
      rack_response({ message: e.message, status: 400 }.to_json, 400)
    end

    # 例外ハンドル 500
    rescue_from :all do |e|
      if Rails.env.development?
        raise e
      else
        error_response(message: "Internal server error", status: 500)
      end
    end

    mount V1::Users
    mount V1::Groups
    mount V1::Dial
    # mount V1::Pushs
  end
end