module V1
  class Groups < Grape::API
    
    helpers do
      params :id do
        requires :id, type: Integer, desc: "Groups id."
      end

      params :attributes do
        requires :name, type: String, desc: 'グループ名'
        requires :host_user_id, type: Integer, desc: 'ホストユーザid'
        optional :is_start, type: Boolean, desc: '選択が開始されたか'
      end

      params :user_group_attributes do
        requires :user_id, type: Integer, desc: 'ユーザid'
        requires :group_id, type: Integer, desc: 'グループid'
        optional :like_user_id, type: Integer, desc: '好きなユーザid'
        optional :is_ready, type: Boolean, desc: '電話をかける準備ができたか'
      end

      def group_params
        ActionController::Parameters.new(params).permit(:name, :host_user_id)
      end

      def user_group_params
        ActionController::Parameters.new(params).permit(:user_id, :group_id, :like_user_id, :is_ready)
      end

      def find_group
        @group = Group.find(params[:id])
      end

      def notification(token, message, data)
        notification = Rpush::Apns::Notification.new
        notification.app = Rpush::Apns::App.find_by_name("FeelingCall") # Rpush::Apns::Appインスタンスを設定
        notification.device_token = token
        unless message.empty?
           notification.alert = message
        end
        notification.data = data
        notification.save!
      end
    end

    resource :user_groups do
      desc 'GET /user_groups'
      get '/' do
        ug = UserGroup.all
        ug.as_json
      end

      desc 'GET /user_groups/:group_id'
      get '/:group_id' do
        UserGroup.where(group_id: params[:group_id])
      end

    end

    resource :groups do
      desc "GET api/v1/groups グループ全取得"
      get '/', jbuilder: 'v1/groups/index' do
        @groups = Group.all
      end

      desc 'GET /api/v1/groups/:id グループ1つ取得'
      params do
        use :id
      end
      get '/:id', jbuilder: 'v1/groups/show' do
        find_group
      end

      desc "post /api/v1/groups/create グループ作成"
      params do
        use :attributes
      end
      post '/create', jbuilder: 'v1/groups/create' do

        user = User.find(params[:host_user_id])  # userが見つからなかったら404エラー
        @group = Group.new(group_params)
        if @group.save
          user_group = UserGroup.new(user_id: user.id, group_id: @group.id)
          user_group.save!
          status 201
        else
          error!({message: "Bad Request", code: 400}, 400)
        end
      end

      desc "post /api/v1/groups/join グループ参加"
      params do
        use :user_group_attributes
      end
      post '/join', jbuilder: 'v1/groups/join' do
        user_id = params[:user_id]
        group_id = params[:group_id]

        user = User.find(user_id)
        @group = Group.find(group_id) # user か group　が見つからなかったら404
        @users = @group.users

        user_group = UserGroup.new(user_group_params)
        if user_group.save

          user_data = Array.new
          @users.each do |user|
            user_data.push({
                id: user.id,
                name: user.name,
                phone_number: user.phone_number,
                sex: user.sex
              })
          end
          data = {
            type: "user_add",
            users: user_data
          }

          # print(data)
          @users.each do |user|
            notification(user.device_token, "", data)
          end
          status 201
        else
          error!({message: "Bad Request", code: 400}, 400)
        end
      end

      desc "put /api/v1/groups/start_select 選択開始"
      params do
        requires :group_id, type: Integer, desc: 'グループid'
      end
      put '/start_select', jbuilder: 'v1/groups/start_select' do
        @group = Group.find(params[:group_id])
        if @group.update( is_start: true )
          users = @group.users
          users.each do |user|
            data = {
              type: "start_select"
            }
            notification(user.device_token, "", data)
          end
          status 200
        else
          error!({message: "Update failed", code: 500}, 500)
        end
      end

      desc "put /api/v1/groups/select_target 気になる子選択"
      params do
        requires :user_id, type: Integer, desc: 'ユーザid'
        requires :group_id, type: Integer, desc: 'グループid'
        requires :like_user_id, type: Integer, desc: '好きなユーザid'
      end
      put '/select_target', jbuilder: 'v1/groups/select_target' do
        group_id = params[:group_id]
        user_id = params[:user_id]

        @user_group = UserGroup.find_by(group_id: group_id, user_id: user_id)
        
        if @user_group.update( like_user_id: params[:like_user_id] )
          if UserGroup.where(group_id: group_id, like_user_id: nil).empty?
            group = Group.find(group_id)
            users = group.users
            users.each do |user|
              data = {
                type: "complete_selection",
                group: {
                  id: group.id,
                  name: group.name
                }
              }
              notification(user.device_token, "投票完了しました", data)
            end
          end

          status 200
        else
          error!({message: "Update failed", code: 500}, 500)
        end
      end

      desc "get /api/v1/groups/ready 準備完了"
      params do
        requires :user_id, type: Integer, desc: 'ユーザid'
        requires :group_id, type: Integer, desc: 'グループid'
      end
      get '/ready/:group_id/:user_id', jbuilder: 'v1/groups/ready' do
        # group_id = Group.find(params[:group_id].to_i).id
        # user_id = User.find(params[:user_id].to_i).id

        @user_group = UserGroup.find_by(group_id: params[:group_id], user_id: params[:user_id])
        
        if @user_group.like_user_id && @user_group.is_ready == true
          @is_ready = true
        else
          @is_ready = false
        end
      end

    end

  end
end