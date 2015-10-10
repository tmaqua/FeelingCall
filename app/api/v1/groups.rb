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

        User.find(params[:host_user_id])  # userが見つからなかったら404エラー
        @group = Group.new(group_params)
        if @group.save
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
        User.find(params[:user_id])
        Group.find(params[:group_id]) # user か group　が見つからなかったら404
        @user_group = UserGroup.new(user_group_params)
        if @user_group.save
          status 201
        else
          error!({message: "Bad Request", code: 400}, 400)
        end
      end

      desc "put /api/v1/groups/start_select 選択開始"
      # params do
      #   use :id
      # end
      put '/start_select', jbuilder: 'v1/groups/start_select' do
        @group = Group.find(params[:group_id])
        @group.is_start = true
        @group.save
      end


    end

  end
end