module V1
  class Users < Grape::API
    
    helpers do
      params :id do
        requires :id, type: Integer, desc: "Users id."
      end

      params :attributes do
        requires :name, type: String, desc: 'ユーザ名'
        requires :sex, type: Integer, desc: '性別'
        requires :phone_number, type: String, desc: '電話番号'
        requires :device_token, type: String, desc: 'デバイストークン'
      end

      def user_params
        ActionController::Parameters.new(params).permit(:name, :sex, :phone_number, :device_token)
      end

      def find_user
        @user = User.find(params[:id])
      end
    end

    resource :users do
      desc "GET api/v1/users ユーザ全取得"
      get '/', jbuilder: 'v1/users/index' do
        @users = User.all
      end

      desc 'GET /api/v1/user/:id ユーザ1つ取得'
      params do
        use :id
      end
      get '/:id', jbuilder: 'v1/users/show' do
        find_user
      end

      desc 'PUT /api/v1/user/:id ユーザ1つデータ変更'
      params do
        use :id
        use :attributes
      end
      put '/:id' do
        find_user
        if @user.update(user_params)
          @user
        else
          error!({message: "Bad Request", code: 400}, 400)
        end
      end

      desc "post /api/v1/user/registユーザ登録"
      params do
        use :attributes
      end
      post '/regist', jbuilder: 'v1/users/regist' do
        @user = User.new(user_params)
        if @user.save
          @status = 201
          status 201
        else
          error!({message: "Bad Request", code: 400}, 400)
        end
      end
    end

  end
end