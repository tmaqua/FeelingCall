module V1
  class Pushs < Grape::API
    
    helpers do
      params :id do
        requires :id, type: Integer, desc: "Users id."
      end

      params :attributes do
        optional :name, type: String, desc: 'ユーザ名'
        optional :sex, type: Integer, desc: '性別'
        optional :phone_number, type: String, desc: '電話番号'
        requires :device_token, type: String, desc: 'デバイストークン'
      end

      def user_params
        ActionController::Parameters.new(params).permit(:name, :sex, :phone_number, :device_token)
      end

      def find_user
        @user = User.find(params[:id])
      end

      def notification(token, message, data)
        notification = Rpush::Apns::Notification.new
        notification.app = Rpush::Apns::App.find_by_name("FeelingCall") # Rpush::Apns::Appインスタンスを設定
        notification.device_token = token
        notification.alert = message
        notification.data = data
        notification.save!
      end
    end

    resource :push do
      desc "GET api/v1/push/test_push/:id ユーザ(id)にpush通知"
      params do
        use :id
      end
      get '/test_push' do
        find_user
        notification(@user.device_token, "FeelingCall Test", {foo: "var"})
      end
    end

  end
end