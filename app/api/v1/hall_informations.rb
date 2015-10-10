module V1
  class HallInformations < Grape::API
    
    helpers do
      params :id do
        requires :id, type: Integer, desc: "HallInformations id."
      end

      def find_hall_information
        @hall_information = HallInformation.find(params[:id])
      end
    end

    resource :hall_informations do
      desc "GET api/v1/hall_informations 式場情報全取得"
      get '/', jbuilder: 'v1/hall_informations/index' do
        @hall_informations = HallInformation.all
      end

      desc 'GET /api/v1/hall_informations/:id 式場情報1つ取得'
      params do
        use :id
      end
      get '/:id', jbuilder: 'v1/hall_informations/show' do
        find_hall_information
      end
    end

  end
end