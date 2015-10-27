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
      # params do
      #   use :id
      # end
      get '/test_push' do
        # find_user
        token = "80f2b46c1710e6b58c871b7e76f79e2c7395a310aed791236915ffb58b58797d"
        data = {
          type: "user_add",
          user: {
            id: 14,
            name: "はなこ",
            phone_num: "000-0000-0000",
            sex: 2
          }
        }

        notification(token, "FeelingCall Test", data)
        data
        # notification(@user.device_token, "FeelingCall Test", {foo: "var"})
      end

      desc "GET api/v1/push/test_push/:id ユーザ(id)にpush通知"
      get '/test_push/:id' do
        find_user
        token = @user.device_token

        print("********token: #{token}************")
        data = {
          type: "user_add",
          user: {
            id: 14,
            name: "はなこ",
            phone_num: "000-0000-0000",
            sex: 2
          }
        }

        notification(token, "FeelingCall Test", data)
        data
        # notification(@user.device_token, "FeelingCall Test", {foo: "var"})
      end

      desc "GET api/v1/push/group/:id グループ(id)にpush通知"
      params do
        requires :id, type: Integer, desc: "Group id."
      end
      get '/test_push' do
        group = UserGroup.find(params[:id])

        # notification(@user.device_token, "FeelingCall Test", {foo: "var"})
      end

    end

  end
end