module V1
  class Groups < Grape::API
    
    helpers do
      params :id do
        requires :id, type: Integer, desc: "Groups id."
      end

      params :attributes do
        requires :name, type: String, desc: 'グループ名'
        requires :host_user_id, type: Integer, desc: 'ホストユーザid'
      end

      def group_params
        ActionController::Parameters.new(params).permit(:name, :host_user_id)
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
        # unless User.find(params[:host_user_id])
        #   error!({message: "Bad Request", code: 400}, 400)
        # end

        User.find(params[:host_user_id])

        @group = Group.new(group_params)
        if @group.save
          @status = 201
          status 201
        else
          error!({message: "Bad Request", code: 400}, 400)
        end
      end
    end

  end
end